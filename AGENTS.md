# AGENTS.md - We Invited V2

## Quick Commands

```bash
# Install dependencies
fvm flutter pub get

# Lint & typecheck
fvm flutter analyze

# Run tests
fvm flutter test

# Code generation (required after modifying .dart files with freezed/json_serializable/riverpod)
fvm dart run build_runner build

# Firebase setup (run once)
flutterfire configure
```

## Architecture

- **State Management**: Riverpod with code generation (`riverpod_annotation`, `riverpod_generator`)
- **Routing**: GoRouter via `app_router.dart`
- **Data Layer**: Freezed for immutable models, JSON serialization
- **Firebase**: Auth, Firestore, Storage (requires `firebase_options.dart` generated via flutterfire)
- **Backend API**: `we-invited-api` (Bun/Express, separate repo)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── src/
│   ├── features/             # Feature-based Clean Architecture
│   │   ├── authentication/  # Auth (login, profile)
│   │   └── events/          # Events, feed, posts
│   ├── common_widgets/      # Shared UI components
│   ├── constants/           # Theme, paths
│   ├── routing/             # GoRouter config, splash
│   └── utils/               # API client, helpers
```

## Important Notes

1. **Firebase setup**: `firebase_options.dart` is commented out in main.dart. Run `flutterfire configure` to generate it
2. **Code generation**: Must run `fvm dart run build_runner build` after creating/modifying models with `@freezed`, `@jsonSerializable`, or `@riverpod`
3. **Custom lints**: Enabled via `riverpod_lint` in analysis_options.yaml
4. **Flutter version**: Managed via FVM (`.fvmrc`)
5. **Code Validation**: Every time you modify a file, you MUST immediately analyze it by running `fvm flutter analyze <file_path>` to ensure there are no errors.
6. **Git Workflow**: NEVER push directly to the `develop` or `main` branches. All updates to `develop` MUST pass through a Pull Request from a feature branch.
