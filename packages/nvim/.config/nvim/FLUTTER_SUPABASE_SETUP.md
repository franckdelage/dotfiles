# Flutter and Supabase Development

## Installed tools

- Flutter uses the stable channel. Update it with `flutter upgrade`.
- The Android SDK lives at `~/Android/Sdk`. Update its packages with `android sdk update`.
- OpenJDK 17 comes from the `jdk17-openjdk` Arch package. Update it with system packages.
- The `medium_phone` Android emulator profile is ready. Start it with `flutter emulators --launch medium_phone`.
- This Omarchy supports Flutter for Android, web, and Linux desktop. Build iOS apps on macOS with Xcode.

## Local Supabase development

- The `supabase`, `docker`, `docker compose`, and `deno` commands are installed.
- Run `supabase start` in an initialized Supabase project.
- The first start downloads the required Docker images.
- Supabase local development requires a running Docker service.

## Per-project dependencies

- Run `flutter pub get` in a Flutter project to fetch its packages.
- Add `supabase_flutter` to projects that use Supabase.
- Let Deno resolve dependencies for Supabase Edge Functions.

## Neovim

- `flutter-tools.nvim` provides Flutter commands and Dart tools.
- Mason installs `postgres-language-server` for SQL files.
