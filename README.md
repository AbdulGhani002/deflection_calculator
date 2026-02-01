# Aluminum Deflection Calculator

A production-ready, cross-platform (iOS/Android) Flutter application for calculating beam deflection of aluminum profiles. Works completely offline with local JSON data and supports English/German localization.

## Features

- ✅ **6 Deflection Scenarios**: Simple beam, Cantilever, Fixed-Fixed with Point or Distributed loads
- ✅ **Offline-First**: All profile data stored locally in JSON
- ✅ **Multi-Language**: English and German support
- ✅ **Material Design 3**: Modern UI with dark/light theme support
- ✅ **TDD-Verified**: Unit-tested calculation engine with 100% formula accuracy
- ✅ **Cross-Platform**: iOS, Android, Web, Windows, macOS, Linux

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| State Management | Provider |
| Localization | Custom map-based (intl-ready) |
| Data Format | Local JSON |
| Testing | flutter_test |

## Project Structure

```
deflection_calculator/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── logic/
│   │   └── calculator_engine.dart   # Deflection formulas
│   ├── models/
│   │   └── profile_model.dart       # Profile data model
│   ├── providers/
│   │   └── app_state.dart           # State management
│   ├── screens/
│   │   └── home_screen.dart         # Main UI
│   └── l10n/
│       └── app_localizations.dart   # Localization strings
├── assets/
│   ├── data/
│   │   └── profiles.json            # Aluminum profile database
│   └── images/                      # Profile images
├── test/
│   └── calculator_test.dart         # Unit tests
└── docs/
    └── USER_MANUAL.md               # End-user documentation
```

## Deflection Formulas

The app implements these standard beam deflection formulas:

| Support Type | Load Type | Formula | Description |
|--------------|-----------|---------|-------------|
| Simple Beam | Point | `F·L³ / (48·E·I)` | Load at center |
| Simple Beam | Distributed | `5·F·L³ / (384·E·I)` | Uniform load |
| Cantilever | Point | `F·L³ / (3·E·I)` | Load at free end |
| Cantilever | Distributed | `F·L³ / (8·E·I)` | Uniform load |
| Fixed-Fixed | Point | `F·L³ / (192·E·I)` | Load at center |
| Fixed-Fixed | Distributed | `F·L³ / (384·E·I)` | Uniform load |

Where:
- **F** = Force (N)
- **L** = Length (mm)
- **E** = Elastic Modulus (N/mm²)
- **I** = Moment of Inertia (mm⁴)

**Important**: Profile data uses cm⁴ for moment of inertia. The engine automatically converts: `1 cm⁴ = 10,000 mm⁴`

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd deflection_calculator

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the app
flutter run
```

## Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requires macOS)

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release

# Output: build/web/
```

## Updating the Profiles Database

The profile data is stored in `assets/data/profiles.json`. To add or modify profiles:

### Profile JSON Structure

```json
{
  "id": "unique_profile_id",
  "name": "Display Name",
  "category": "Series/Category",
  "image_asset": "assets/images/profile_image.png",
  "ix_cm4": 9.7,
  "iy_cm4": 9.7,
  "e_modulus": 70000
}
```

### Field Descriptions

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique identifier for the profile |
| `name` | String | Display name shown in the UI |
| `category` | String | Grouping category (e.g., "Series 8") |
| `image_asset` | String | Path to profile cross-section image |
| `ix_cm4` | Number | Moment of inertia about X-axis (cm⁴) |
| `iy_cm4` | Number | Moment of inertia about Y-axis (cm⁴) |
| `e_modulus` | Number | Elastic modulus in N/mm² (70,000 for aluminum) |

### Adding a New Profile

1. Open `assets/data/profiles.json`
2. Add a new JSON object to the array
3. Optionally add a profile image to `assets/images/`
4. Rebuild the app

### Example: Adding a Custom Profile

```json
{
  "id": "custom_100x50",
  "name": "Custom Profile 100x50",
  "category": "Custom",
  "image_asset": "assets/images/100x50.png",
  "ix_cm4": 45.2,
  "iy_cm4": 12.8,
  "e_modulus": 70000
}
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/calculator_test.dart
```

## Localization

The app supports English and German. To add a new language:

1. Open `lib/l10n/app_localizations.dart`
2. Add a new `AppLocale` enum value
3. Add translations to `_localizedStrings` map
4. Update the language toggle in the UI

## License

MIT License - See LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Submit a pull request

## Support

For issues and feature requests, please use the GitHub issue tracker.
