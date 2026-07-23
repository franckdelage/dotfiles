# Remaining Flutter and Supabase Setup

## Android target

- Install Android SDK through Android Studio's first-launch setup.
- Install Android SDK Platform.
- Install Android SDK Build-Tools.
- Install Android SDK Command-line Tools.
- Install Android Emulator.
- Create at least one Android Virtual Device with a system image.
- Accept Android licenses:

  ```sh
  flutter doctor --android-licenses
  ```

## iOS and macOS targets

- Install full Xcode from the App Store.
- Install an iOS Simulator runtime.
- Install Xcode first-launch components.
- Select the Xcode developer directory.
- Install Rosetta 2 if required by Apple Silicon tooling.

## Supabase local development

No additional package installation is required.

- Start Rancher Desktop.
- Run `supabase start` from a Supabase project.
- The first start downloads the required Supabase Docker images.

## Per-project dependencies

- Fetch Flutter packages with `flutter pub get`.
- Add the `supabase_flutter` package when required by the application.
- Let Deno resolve dependencies used by Supabase Edge Functions.

## Optional tooling

- PostgreSQL client tools such as `psql`.
- Additional Android SDK platforms and emulator system images.
- Physical-device drivers and provisioning.
- Apple Developer account and signing configuration for physical iOS devices or distribution.

## Neovim

No additional Neovim plugins or Mason tools are required.
