# Bunkr (Flutter App)

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
- **Cross-Platform** 📱 – Access your attendance data on Android, iOS, and the web

<br />

## 🛠️ Tech Stack

- **Framework** – Flutter 3.6 (Dart)
- **State Management** – Provider
- **UI Components** – shadcn_ui, Lucide Icons, Awesome Flutter Extensions
- **Networking** – Dio, Supabase, Firebase Messaging
- **Notifications** – Firebase Cloud Messaging, flutter_local_notifications
- **Persistence** – Shared Preferences, flutter_secure_storage
- **Other** – Table Calendar, dotenv, connectivity_plus

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
assets/
├── fonts/                   # Custom fonts
├── images/                  # App images
android/                     # Android-specific code and configs
ios/                         # iOS-specific code and configs
web/                         # Web support
```

<br />

## 🔌 API & Environment Setup

Create a `.env` file in the project root and add your API keys and endpoints:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
EZYGO_API_URL=
```

<br />

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio/Xcode (for mobile development)
- A device or emulator

### Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/ABHAY-100/bunkr-app.git
   ```

2. **Navigate to Project Directory**
   ```bash
   cd bunkr-app
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Create `.env` file and add API keys**

5. **Run the App**
   - For Android
     
     ```bash
     flutter run
     ```
   - For Web
     
     ```bash
     flutter run -d chrome
     ```

<br />

## 🤝 Contributing

We welcome contributions! Here’s how you can help:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

<br />

## 👥 Team

- [Abhay Balakrishnan](https://github.com/ABHAY-100)
- [Asil Mehaboob](https://github.com/AsilMehaboob)
- [Sreyas B Anand](https://github.com/sreyas-b-anand)

<br />

## 📧 Contact

For any questions, feel free to reach out to me via email at [asilmehaboob@gmail.com](mailto:asilmehaboob@gmail.com)

<br />

## 📄 License

This project is licensed under the **GNU General Public License v3.0** – see the [LICENSE](LICENSE) file for details.

<br />

***Thank you for your interest in Bunkr! 🤝*** 
