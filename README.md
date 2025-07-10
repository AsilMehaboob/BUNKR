# Bunkr

## Overview

Bunkr is a student-focused attendance tracker that gives you the insights you actually need. Built as a better alternative to Ezygo, it presents your attendance data with a clean, intuitive interface that makes sense to students. No more confusing numbers—just clear, actionable insights!

*Also available as a web app: [bunkr-web](https://github.com/ABHAY-100/bunkr-web)*

<br />

## 🎯 Features

- **Smart Skip Calculator** 🧮 – Know exactly how many classes you can miss while staying above attendance requirements
- **Better Data Presentation** 📈 – Clean, user-friendly interface that actually makes your attendance data understandable
- **Ezygo Integration** 🔄 – Use your existing Ezygo credentials—no new accounts needed
- **Real-time Updates** ⚡ – Get instant updates on your attendance status and skip calculations
- **Track Status Changes** 📝 – Get notified when your attendance is updated
- **Cross-Platform** 📱 – Available on Android, iOS, and Web

<br />

## 🛠️ Tech Stack

- **Framework** – Flutter 3.32 (Dart)
- **Backend & Messaging (Notifications)** – Supabase, Firebase
- **UI Components** – shadcn, Material, Cupertino

<br />

## 📁 Project Structure

```
lib/
├── main.dart                # App entry point
├── screens/                 # Main screens
├── services/                # Business logic and integrations
├── models/                  # Data models
├── widgets/                 # Reusable UI components
├── helpers/                 # Utility functions

android/                     # Android-specific code and configs
ios/                         # iOS-specific code and configs
web/                         # Web support files
assets/                      # Fonts and images
```

<br />

## 🔌 API & Environment Setup

Create a `.env` file in the project root and add API keys and endpoints

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
EZYGO_API_URL=
```

You will also need to add your Firebase configuration files
- `google-services.json` for Android
- `firebase_options.dart` for Flutter

<br />

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.32 or later)
- Android Studio or VS Code (for mobile development)
- A device or emulator

### Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/AsilMehaboob/BUNKR.git
   ```

2. **Navigate to Project Directory**
   ```bash
   cd BUNKR
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Create `.env` file and add API keys**

5. **Add Firebase configuration files** (see above)

6. **Run the App**
   ```bash
   flutter run
   ```

The application will be available on your Android device or emulator

<br />

## 🤝 Contributing

We welcome contributions! Here’s how you can help

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

<br />

## 👥 Team

- [Asil Mehaboob](https://github.com/AsilMehaboob)
- [Abhay Balakrishnan](https://github.com/ABHAY-100)
- [Sreyas B Anand](https://github.com/sreyas-b-anand)

<br />

## 📧 Contact

For any questions, feel free to reach out to me via email at [asilmehaboob@gmail.com](mailto:asilmehaboob@gmail.com)

<br />

## 📄 License

This project is licensed under the **GNU General Public License v3.0** – see the [LICENSE](LICENSE) file for details

<br />

***Thank you for your interest in Bunkr! 🤝*** 
