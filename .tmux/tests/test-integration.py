#!/usr/bin/env python3
"""Test tmux on isolated sockets. Test sessions exit through their own shell."""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import time
import unittest
import uuid

TMUX_DIR = Path(__file__).resolve().parents[1]


class TmuxServerTests(unittest.TestCase):
  simulate_macos = False

  @classmethod
  def setUpClass(cls):
    cls.temp = tempfile.TemporaryDirectory(prefix="tmux-config-test-")
    cls.path = Path(cls.temp.name)
    cls.done = cls.path / "done"
    cls.socket = "dotfiles-test-" + uuid.uuid4().hex
    cls.env = dict(os.environ)
    cls.env.pop("TMUX", None)
    if cls.simulate_macos:
      bin_dir = cls.path / "bin"
      bin_dir.mkdir()
      uname = bin_dir / "uname"
      uname.write_text("#!/bin/sh\nprintf 'Darwin\\n'\n")
      uname.chmod(0o755)
      cls.env["PATH"] = str(bin_dir) + ":" + cls.env["PATH"]
    command = f"while [ ! -e {shlex.quote(str(cls.done))} ]; do sleep 0.1; done"
    result = cls.tmux(
      "-f", str(TMUX_DIR / "tmux.conf"),
      "new-session", "-d", "-s", "dotfiles-test", command,
    )
    if result.returncode:
      cls.done.touch()
      cls.temp.cleanup()
      raise RuntimeError(result.stderr)
    cls.startup_stderr = result.stderr
    if not cls.simulate_macos:
      accent = subprocess.run(["omarchy-theme-color", "accent", "blue"],
                              capture_output=True, text=True, check=True).stdout.strip()
      # The startup command and the session hook can apply the palette together.
      # The script sets clock-mode-colour last, but another job can still run.
      for _ in range(100):
        color = cls.tmux("show-options", "-gqv", "clock-mode-colour").stdout.strip()
        jobs = cls.tmux("show-messages", "-J").stdout
        if color == accent and "omarchy-theme.sh" not in jobs:
          break
        time.sleep(0.05)
      else:
        cls.done.touch()
        raise RuntimeError("The startup theme hook did not finish.")

  @classmethod
  def tearDownClass(cls):
    cls.done.touch()
    for _ in range(100):
      if cls.tmux("has-session").returncode:
        break
      time.sleep(0.1)
    else:
      raise RuntimeError(f"Test session did not exit: {cls.socket}")
    cls.temp.cleanup()

  @classmethod
  def tmux(cls, *args):
    return subprocess.run(
      ["tmux", "-L", cls.socket, *args], env=cls.env,
      capture_output=True, text=True, check=False, timeout=30,
    )

  def option(self, name):
    result = self.tmux("show-options", "-gqv", name)
    self.assertEqual(result.returncode, 0, result.stderr)
    return result.stdout.strip()

  def test_startup_has_no_errors(self):
    self.assertEqual(self.startup_stderr, "")
    self.assertEqual(self.option("prefix"), "C-a")
    self.assertEqual(self.option("history-limit"), "20000")
    self.assertEqual(self.option("status-position"), "top")

  def test_no_f7_or_old_omarchy_shortcuts(self):
    bindings = self.tmux("list-keys").stdout
    self.assertNotIn("F7", bindings)
    self.assertNotIn(" -T off ", bindings)
    root = self.tmux("list-keys", "-T", "root").stdout
    self.assertNotIn("M-1 ", root)
    self.assertNotIn("omarchy-menu-tmux-keybindings", bindings)

  def test_shared_keys_and_floax(self):
    result = self.tmux("list-keys", "-T", "prefix")
    self.assertEqual(result.returncode, 0, result.stderr)
    bindings = {}
    for line in result.stdout.splitlines():
      fields = line.split()
      bindings[fields[fields.index("prefix") + 1]] = line
    for key, command in (("C-r", str(Path.home() / ".tmux/tmux.conf")),
                         ("|", "split-window"), ("_", "split-window"),
                         ("L", "sesh last"), ("h", "floax"),
                         ("T", "fzf-tmux"), ("G", "gum filter")):
      self.assertIn(key, bindings)
      self.assertIn(command, bindings[key])
    result = self.tmux("list-keys", "-T", "copy-mode-vi")
    self.assertIn("yank.sh", result.stdout)

  def test_plugins_exist(self):
    for plugin in self.option("@tpm_plugins").split():
      name = plugin.rsplit("/", 1)[-1].split("#", 1)[0]
      self.assertTrue((Path.home() / ".tmux-plugins" / name / ".git").exists(), name)

  def test_reload_does_not_duplicate_formats_or_arrays(self):
    names = ("status-left", "status-right", "terminal-features", "terminal-overrides",
             "@tpm_plugins", "status-style", "window-status-current-format")
    before = {name: self.option(name) for name in names}
    for _ in range(2):
      result = self.tmux("source-file", str(TMUX_DIR / "tmux.conf"))
      self.assertEqual(result.returncode, 0, result.stderr)
      self.assertEqual(result.stderr, "")
    after = {name: self.option(name) for name in names}
    self.assertEqual(after, before)

  def test_light_and_dark_palettes_keep_the_shared_keys(self):
    if self.simulate_macos:
      self.assertEqual(self.option("@dotfiles_omarchy"), "off")
      return
    bin_dir = self.path / "palette-bin"
    bin_dir.mkdir(exist_ok=True)
    resolver = bin_dir / "omarchy-theme-color"
    env = dict(self.env, PATH=str(bin_dir) + ":" + self.env["PATH"])
    before = self.tmux("list-keys", "-T", "prefix").stdout
    try:
      for background, foreground in (("#eeeeee", "#111111"), ("#111111", "#eeeeee")):
        resolver.write_text(
          "#!/bin/sh\ncase \"$1\" in\n"
          f"background) printf '{background}' ;;\n"
          f"foreground) printf '{foreground}' ;;\n"
          "accent) printf '#4488ff' ;;\n"
          "muted) printf '#666666' ;;\n"
          "selection) printf '#888888' ;;\nesac\n"
        )
        resolver.chmod(0o755)
        subprocess.run(["bash", str(TMUX_DIR / "omarchy-theme.sh"), "-L", self.socket],
                       env=env, capture_output=True, check=True)
        self.assertEqual(self.option("status-style"),
                         f"bg={background},fg={foreground}")
        self.assertEqual(self.tmux("list-keys", "-T", "prefix").stdout, before)
    finally:
      subprocess.run(["bash", str(TMUX_DIR / "omarchy-theme.sh"), "-L", self.socket],
                     env=self.env, capture_output=True, check=True)

  def test_platform_appearance(self):
    if self.simulate_macos:
      self.assertEqual(self.option("@dotfiles_omarchy"), "off")
      self.assertIn("catppuccin/tmux", self.option("@tpm_plugins"))
      self.assertEqual(self.option("@catppuccin_flavor"), "mocha")
      self.assertTrue(self.option("@catppuccin_status_session"))
      right = self.option("status-right")
      self.assertIn("cpu_percentage.sh", right)
      self.assertIn("battery_percentage.sh", right)
      self.assertIn("@catppuccin_status_date_time", right)
    else:
      self.assertEqual(self.option("@dotfiles_omarchy"), "on")
      self.assertNotIn("catppuccin", self.option("@tpm_plugins"))
      self.assertEqual(self.option("@catppuccin_status_session"), "")
      colors = []
      for key in ("background", "foreground"):
        result = subprocess.run(["omarchy-theme-color", key], capture_output=True,
                                text=True, check=True)
        colors.append(result.stdout.strip())
      self.assertEqual(self.option("status-style"), f"bg={colors[0]},fg={colors[1]}")
      self.assertIn("COPY", self.option("status-right"))
      self.assertIn("PREFIX", self.option("status-right"))
      self.assertIn("ZOOM", self.option("status-right"))


class MacosBranchTests(TmuxServerTests):
  simulate_macos = True


if __name__ == "__main__":
  unittest.main()
