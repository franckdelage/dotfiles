#!/usr/bin/env python3
"""Test the shared tmux configuration without a desktop or a live session."""

import base64
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

TMUX_DIR = Path(__file__).resolve().parents[1]
ROOT = TMUX_DIR.parent


class ClipboardTests(unittest.TestCase):
  def setUp(self):
    self.temp = tempfile.TemporaryDirectory()
    self.addCleanup(self.temp.cleanup)
    self.path = Path(self.temp.name)
    self.bin = self.path / "bin"
    self.bin.mkdir()
    for command in ("bash", "cat", "wc", "head", "base64", "tr", "awk"):
      os.symlink(shutil.which(command), self.bin / command)
    self.output = self.path / "clipboard"
    self.tty = self.path / "tty"
    self.tty.touch()
    self.env = {
      "PATH": str(self.bin),
      "HOME": str(self.path),
      "CLIPBOARD_OUTPUT": str(self.output),
      "TEST_TTY": str(self.tty),
      "WAYLAND_DISPLAY": "wayland-test",
      "DISPLAY": ":0",
    }
    self.command("tmux", '''
case "$*" in
  *"@copy_use_osc52_fallback"*) printf '%s' "${TEST_OSC52:-on}" ;;
  *"pane_tty"*) printf '%s' "$TEST_TTY" ;;
esac
''')

  def command(self, name, body):
    script = self.bin / name
    script.write_text("#!/bin/sh\nset -eu\n" + body)
    script.chmod(0o755)

  def run_copy(self, data):
    return subprocess.run(
      [str(self.bin / "bash"), str(TMUX_DIR / "yank.sh")],
      input=data, env=self.env, capture_output=True, check=False,
    )

  def test_wayland_precedes_x11_and_keeps_newlines(self):
    self.command("wl-copy", 'cat > "$CLIPBOARD_OUTPUT"')
    self.command("xsel", 'exit 81')
    result = self.run_copy("café\n\n".encode())
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.output.read_bytes(), "café\n\n".encode())

  def test_macos_copy_keeps_newlines(self):
    self.command("pbcopy", 'cat > "$CLIPBOARD_OUTPUT"')
    result = self.run_copy(b"mac\n\n")
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.output.read_bytes(), b"mac\n\n")

  def test_macos_namespace_wrapper(self):
    self.command("pbcopy", 'cat > "$CLIPBOARD_OUTPUT"')
    self.command("reattach-to-user-namespace", 'test "$1" = pbcopy\nexec pbcopy')
    result = self.run_copy(b"namespace\n")
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.output.read_bytes(), b"namespace\n")

  def test_x11_without_wayland(self):
    self.env.pop("WAYLAND_DISPLAY")
    self.command("wl-copy", 'exit 82')
    self.command("xsel", 'cat > "$CLIPBOARD_OUTPUT"')
    result = self.run_copy(b"x11\n")
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.output.read_bytes(), b"x11\n")

  def test_backend_error_reaches_the_caller(self):
    self.command("wl-copy", 'printf "copy failed\\n" >&2\nexit 23')
    result = self.run_copy(b"failure")
    self.assertEqual(result.returncode, 23)
    self.assertIn(b"copy failed", result.stderr)

  def test_osc52_without_a_local_backend(self):
    data = b"osc52\n\n"
    result = self.run_copy(data)
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertIn(base64.b64encode(data), self.tty.read_bytes())
    self.assertTrue(self.tty.read_bytes().startswith(b"\x1bPtmux;"))

  def test_osc52_disabled(self):
    self.env["TEST_OSC52"] = "off"
    result = self.run_copy(b"disabled")
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.tty.read_bytes(), b"")

  def test_copy_from_a_file(self):
    self.command("wl-copy", 'cat > "$CLIPBOARD_OUTPUT"')
    source = self.path / "input"
    source.write_bytes(b"file\n\n")
    result = subprocess.run(
      [str(self.bin / "bash"), str(TMUX_DIR / "yank.sh"), str(source)],
      env=self.env, capture_output=True, check=False,
    )
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertEqual(self.output.read_bytes(), source.read_bytes())


class ConfigurationTests(unittest.TestCase):
  def test_no_remote_configuration_or_f7(self):
    self.assertFalse((TMUX_DIR / "tmux.remote.conf").exists())
    for path in TMUX_DIR.iterdir():
      if path.suffix in (".conf", ".sh"):
        text = path.read_text()
        for obsolete in ("F7", "tmux.remote.conf", "SSH_CLIENT", "remote_tunnel_port"):
          self.assertNotIn(obsolete, text, str(path))

  def test_omarchy_hook_targets_only_the_standard_server(self):
    hook = (TMUX_DIR / "omarchy-theme-hook.sh").read_text()
    self.assertIn('"$HOME/.tmux/omarchy-theme.sh" -L default', hook)

  def test_active_sesh_config_is_local(self):
    ignore = (ROOT / ".stow-local-ignore").read_text()
    self.assertIn(r"^/\.config/sesh/sesh\.toml$", ignore)
    self.assertTrue((ROOT / ".config/sesh/sesh-macos.toml").exists())

  def test_gum_binding_uses_shared_supported_options(self):
    bindings = (TMUX_DIR / "keybindings.conf").read_text()
    gum_command = next(line for line in bindings.splitlines() if "gum filter" in line)
    self.assertNotIn("--no-sort", gum_command)
    self.assertIn("--limit 1", gum_command)

  def test_portable_reload(self):
    self.assertIn(
      "bind C-r source-file ~/.tmux/tmux.conf",
      (TMUX_DIR / "keybindings.conf").read_text(),
    )

  def test_macos_entrypoint(self):
    self.assertEqual(
      (ROOT / ".tmux.conf").read_text().strip(),
      "source-file ~/.tmux/tmux.conf",
    )

  def test_linux_session_template(self):
    import tomllib
    config = tomllib.loads((ROOT / ".config/sesh/sesh-linux.toml").read_text())
    self.assertEqual([session["name"] for session in config["session"]],
                     ["Home", "Dotfiles"])
    self.assertEqual(config["blacklist"], ["scratch", "floax"])
    self.assertNotIn("/Applications", str(config))


class StowTests(unittest.TestCase):
  def test_stow_preserves_local_profiles_and_excludes_tests(self):
    with tempfile.TemporaryDirectory() as temp:
      root = Path(temp)
      package = root / "packages" / "dotfiles"
      target = root / "home"
      for directory in (package / ".config/sesh", package / ".tmux/tests",
                        package / ".pi", target / ".config/sesh", target / ".tmux"):
        directory.mkdir(parents=True, exist_ok=True)
      shutil.copy(ROOT / ".stow-local-ignore", package / ".stow-local-ignore")
      (package / ".config/sesh/sesh.toml").write_text("shared")
      (package / ".config/sesh/sesh-macos.toml").write_text("template")
      (package / ".tmux/tmux.conf").write_text("config")
      (package / ".tmux/tests/test-config.py").write_text("test")
      (package / ".pi/lsp.json").write_text("{}")
      local = target / ".config/sesh/sesh.toml"
      local.write_text("machine-local")
      result = subprocess.run(
        ["stow", "--dir", str(package.parent), "--target", str(target), "dotfiles"],
        capture_output=True, text=True, check=False,
      )
      self.assertEqual(result.returncode, 0, result.stderr)
      self.assertEqual(local.read_text(), "machine-local")
      self.assertFalse(local.is_symlink())
      self.assertTrue((target / ".tmux/tmux.conf").is_symlink())
      self.assertFalse((target / ".tmux/tests").exists())
      self.assertFalse((target / ".pi").exists())


class ThemeTests(unittest.TestCase):
  def setUp(self):
    self.temp = tempfile.TemporaryDirectory()
    self.addCleanup(self.temp.cleanup)
    self.path = Path(self.temp.name)
    self.bin = self.path / "bin"
    self.bin.mkdir()
    self.log = self.path / "tmux.log"
    self.env = dict(os.environ, PATH=str(self.bin), TEST_LOG=str(self.log))
    self.command("tmux", '''
if [ "$*" = "list-sessions" ] || [ "$*" = "-L test-theme list-sessions" ]; then
  exit "${TEST_NO_SERVER:-0}"
fi
printf '%s\\n' "$*" >> "$TEST_LOG"
''')
    self.command("omarchy-theme-color", '''
case "$1" in
  background) printf '#101010' ;;
  foreground) printf '#eeeeee' ;;
  accent) test "${TEST_NO_ACCENT:-0}" = 0 && printf '#ff8800' ;;
  blue) printf '#4488ff' ;;
  muted) printf '#666666' ;;
  selection) printf '#333333' ;;
esac
''')

  def command(self, name, body):
    path = self.bin / name
    path.write_text("#!/bin/sh\nset -eu\n" + body)
    path.chmod(0o755)

  def run_theme(self, *args):
    return subprocess.run(
      ["/bin/bash", str(TMUX_DIR / "omarchy-theme.sh"), *args],
      env=self.env, capture_output=True, check=False,
    )

  def test_palette_and_socket(self):
    result = self.run_theme("-L", "test-theme")
    self.assertEqual(result.returncode, 0, result.stderr)
    log = self.log.read_text()
    self.assertIn("-L test-theme set-option -g status-style bg=#101010,fg=#eeeeee", log)
    self.assertIn("#ff8800", log)

  def test_blue_when_accent_is_missing(self):
    self.env["TEST_NO_ACCENT"] = "1"
    result = self.run_theme()
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertIn("#4488ff", self.log.read_text())

  def test_missing_theme_uses_a_reported_fallback(self):
    self.command("omarchy-theme-color", "exit 1")
    result = self.run_theme()
    self.assertEqual(result.returncode, 0)
    self.assertIn(b"fallback", result.stderr)
    self.assertIn("status-style", self.log.read_text())

  def test_no_server_does_not_start_one(self):
    self.env["TEST_NO_SERVER"] = "1"
    result = self.run_theme()
    self.assertEqual(result.returncode, 0, result.stderr)
    self.assertFalse(self.log.exists())


if __name__ == "__main__":
  unittest.main()
