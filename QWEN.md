# We Invited V2 - QWEN.md

## Project Overview

**We Invited V2** is a Flutter mobile application for event management and social networking. The app enables users to create, browse, and manage events with a modern feature-based Clean Architecture.

### Key Technologies

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.41.6 (managed via FVM) |
| **Language** | Dart SDK ^3.8.1 |
| **State Management** | Riverpod (with code generation) |
| **Routing** | GoRouter (shell routes for bottom navigation) |
| **Data Models** | Freezed + JSON Serializable |
| **Backend Services** | Firebase (Auth, Firestore, Storage) |
| **External API** | `we-invited-api` (Bun/Express, separate repo) |
| **HTTP Client** | Dio with secure storage |

### Architecture

The project follows **feature-based Clean Architecture**:

```
lib/
├── main.dart                     # Entry point (Riverpod ProviderScope + MaterialApp.router)
├── src/
│   ├── features/                 # Feature modules
│   │   ├── authentication/       # Login, register, profile screens + controllers
│   │   └── events/               # Home feed, event detail, create event screens + models
│   ├── common_widgets/           # Reusable UI components
│   ├── constants/                # App theme, constants
│   ├── exceptions/               # Custom exception types
│   ├── routing/                  # GoRouter configuration, splash, main scaffold
│   └── utils/                    # API client, helpers
```

**Routing structure:**
- `/splash` → Splash screen (initial loading)
- `/login` / `/register` → Authentication screens
- `/feed` → Home screen (with nested `/feed/event` for detail)
- `/create` → Create event screen
- `/profile` → User profile screen

The bottom navigation uses `StatefulShellRoute` with three branches: Feed, Create, Profile.

---

## Building and Running

### Prerequisites

- **Flutter 3.41.6** (managed via FVM — see `.fvmrc`)
- **Firebase project** configured (run `flutterfire configure` to generate `firebase_options.dart`)

### Essential Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Lint & typecheck
flutter analyze

# Run tests
flutter test

# Code generation (required after modifying .dart files with @freezed, @jsonSerializable, or @riverpod)
dart run build_runner build

# Watch mode for code generation
dart run build_runner watch

# Firebase setup (run once)
flutterfire configure
```

### Important Notes

1. **Firebase Setup**: The `firebase_options.dart` import is commented out in `main.dart`. You must run `flutterfire configure` to generate it before the app can connect to Firebase.
2. **Code Generation**: After creating or modifying models with `@freezed`, `@jsonSerializable`, or `@riverpod` annotations, you **must** run `dart run build_runner build` to regenerate the `.g.dart` and `.freezed.dart` files.
3. **API Client**: The `ApiClient` is initialized in tests for offline-safe mock environments. The actual backend (`we-invited-api`) is a separate Bun/Express repository.

---

## Development Conventions

### State Management

- Uses **Riverpod with code generation** (`riverpod_annotation` + `riverpod_generator`)
- Controllers are defined with `@riverpod` annotations and generated
- `ProviderScope` wraps the entire app in `main.dart`
- Custom lint plugin (`riverpod_lint`) is enabled via `analysis_options.yaml`

### Data Models

- **Freezed** for immutable data classes with copy-with, equality, and pattern matching
- **JSON Serializable** for JSON serialization/deserialization
- Models use `@freezed` and `@JsonSerializable` annotations

### UI/UX

- World-class animations via `flutter_animate`
- Shimmer loading states via `shimmer`
- SVG support via `flutter_svg`
- Custom fonts via `google_fonts`
- Network image caching via `cached_network_image`

### Testing

- Widget tests live in `/test`
- Tests wrap widgets in `ProviderScope` for Riverpod compatibility
- `ApiClient.initialize()` is called in tests for mock environment setup
- Example: `widget_test.dart` verifies app initialization without crashes

### Linting

- `flutter_lints` as base lint rules
- `custom_lint` with `riverpod_lint` plugin for Riverpod-specific analysis
- Configured in `analysis_options.yaml`

---

## Project Files Reference

| File | Purpose |
|---|---|
| `pubspec.yaml` | Dependencies, Flutter config |
| `analysis_options.yaml` | Lint rules, custom_lint plugins |
| `.fvmrc` | FVM Flutter version (3.41.6) |
| `lib/main.dart` | App entry point, Firebase init, Riverpod setup |
| `lib/src/routing/app_router.dart` | GoRouter config with auth redirects and shell routes |
| `lib/src/routing/main_scaffold.dart` | Bottom navigation scaffold |
| `lib/src/routing/splash_screen.dart` | Splash screen |
| `lib/src/constants/app_theme.dart` | Light theme definition |
| `lib/src/utils/api_client.dart` | API client for backend communication |
| `test/widget_test.dart` | Smoke test for app initialization |
| `test/sit_auth_test.dart` | Authentication integration tests |
