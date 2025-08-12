---
description: Repository Information Overview
alwaysApply: true
---

# Numero Uno Information

## Summary
Numero Uno is a comprehensive Flutter application that calculates and analyzes numerological values based on user's personal information. It provides detailed insights into five core numerological numbers: Life Path, Birthday, Expression, Soul Urge, and Personality numbers.

## Structure
- **lib/**: Core application code organized in MVVM architecture
  - **config/**: App configuration (theme, routing)
  - **models/**: Data models with Hive entities
  - **providers/**: Riverpod state providers
  - **services/**: Business logic services
  - **viewmodels/**: State management logic
  - **views/**: UI components (screens and widgets)
  - **utils/**: Utility functions
- **test/**: Unit and widget tests
- **android/**, **ios/**, **web/**, **windows/**, **macos/**, **linux/**: Platform-specific code

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.8.1
**Framework**: Flutter
**Package Manager**: pub (Flutter)

## Dependencies
**Main Dependencies**:
- **State Management**: hooks_riverpod ^2.4.9, flutter_hooks ^0.21.2
- **Navigation**: go_router ^16.0.0
- **Storage**: shared_preferences ^2.2.2, hive ^2.2.3, hive_flutter ^1.1.0
- **UI/UX**: google_fonts ^6.1.0, flutter_animate ^4.3.0
- **Firebase**: firebase_core ^3.6.0, cloud_firestore ^5.4.4, firebase_auth ^5.3.1
- **Utilities**: intl ^0.20.2, equatable ^2.0.5, url_launcher ^6.3.2

**Development Dependencies**:
- flutter_lints ^6.0.0
- mockito ^5.4.4
- hive_generator ^2.0.1
- build_runner ^2.4.7

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Generate code for Hive models
flutter packages pub run build_runner build

# Run the app
flutter run

# Build for production
flutter build apk --release      # Android
flutter build ios --release      # iOS
flutter build web --release      # Web
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

## Testing
**Framework**: flutter_test
**Test Location**: test/ directory
**Naming Convention**: *_test.dart
**Run Command**:
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

## Key Components
**Models**:
- `NumerologyResult`: Core result data structure
- `UserData`: User input data model
- `AppState`: Application state management

**Services**:
- `NumerologyService`: Core calculation engine
- `StorageService`: Data persistence layer using Hive

**Providers**:
- `appStateProvider`: Global app state
- `inputFormProvider`: Form state management
- `themeProvider`: Theme switching

**Screens**:
- `WelcomeScreen`: Main input form
- `ResultOverviewScreen`: Results summary
- `DetailScreen`: Individual number details

## Firebase Integration
**Configuration**: firebase_options.dart
**Services**: Authentication, Firestore
**Features**: User data storage, result sharing