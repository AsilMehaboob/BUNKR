# Bunkr

A simple, student-only alternative to Ezygo. Bunkr is a Flutter-based mobile application designed to help students manage their attendance and academic activities.

## Features

- Student-focused attendance management
- Secure authentication system
- Modern and intuitive user interface
- Cross-platform support (iOS, Android, Web, Desktop)

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code (recommended IDE)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/AsilMehaboob/bunkr.git
cd bunkr
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your environment variables (if required)

4. Run the app:
```bash
flutter run
```

## Project Structure

```
bunkr/
├── lib/              # Main source code
│   ├── assets/       # Images, icons, and other static assets
│   └── ...
├── test/             # Test files
├── android/          # Android-specific files
├── ios/             # iOS-specific files
├── web/             # Web-specific files
├── windows/         # Windows-specific files
├── linux/           # Linux-specific files
└── macos/           # macOS-specific files
```

## Dependencies

- **flutter_secure_storage**: ^9.0.0 - For secure data storage
- **dio**: ^5.7.0 - For HTTP requests
- **google_fonts**: ^6.0.0 - For custom typography
- **intl**: ^0.18.1 - For internationalization
- **flutter_svg**: ^2.1.0 - For SVG support
- **badges**: ^3.0.0 - For notification badges
- **provider**: ^6.1.5 - For state management
- **flutter_dotenv**: ^5.2.1 - For environment variables

## Development

### Code Style

This project follows the Flutter style guide and uses `flutter_lints` for code quality. Run the following command to check for linting issues:

```bash
flutter analyze
```

### Running Tests

To run the test suite:

```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the terms of the license included in the repository.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors who have helped shape this project
