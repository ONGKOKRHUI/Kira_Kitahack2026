# Kira Carbon Tracker - Flutter App

A Flutter implementation of the Kira Carbon Tracker for Malaysian SMEs, providing carbon footprint tracking, GITA tax savings, and GHG Protocol-compliant reporting.

## 🚀 Quick Start

```bash
# Get dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on Android (if SDK installed)
flutter run

# Build for release
flutter build web
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   ├── routes.dart              # GoRouter configuration
│   └── theme.dart               # Material 3 theme
├── core/
│   └── constants/
│       ├── colors.dart          # Kira color palette
│       ├── spacing.dart         # 4px grid spacing
│       └── typography.dart      # Inter font styles
├── features/
│   ├── dashboard/               # Home screen (hero, charts)
│   ├── scan/                    # Receipt upload
│   ├── assets/                  # GITA savings
│   ├── emissions/               # CO₂ by scope
│   └── reports/                 # Report generation
├── shared/
│   ├── widgets/                 # Reusable components
│   │   ├── kira_card.dart       # Glassmorphism card
│   │   ├── kira_button.dart     # Primary/secondary buttons
│   │   ├── kira_badge.dart      # Status badges
│   │   ├── bottom_nav_bar.dart  # Tab navigation
│   │   ├── floating_ai_button.dart
│   │   ├── period_selector.dart
│   │   └── profile_avatar.dart
│   └── layouts/
│       └── main_scaffold.dart   # Screen wrapper
└── data/                        # Backend integration (prepared)
    ├── models/
    ├── repositories/
    └── services/
```

## 🎨 Design System

Based on the React implementation with:
- **Colors**: Emerald green palette (#10B981 primary)
- **Typography**: Inter font family
- **Effects**: Glassmorphism with backdrop blur
- **Animations**: Fade transitions between screens

## 🔌 Backend Integration Ready

The architecture uses a **Repository Pattern** for easy backend swapping:

```dart
// Current: Mock data
final receiptRepository = MockReceiptRepository();

// Future: Firebase
// final receiptRepository = FirebaseReceiptRepository();
```

Prepared for:
- Firebase Firestore
- Firebase Storage
- Gemini AI (via Firebase Genkit)
- Cloud Functions

## 📱 Features

1. **Dashboard** - Total emissions, scope breakdown pie chart, monthly trend
2. **Scan** - Upload receipts via camera/files
3. **Assets (GITA)** - Track green asset tax savings
4. **Emissions** - View CO₂e by scope with source breakdown
5. **Reports** - GHG Protocol compliant report generation

## 🛠 Tech Stack

- **Framework**: Flutter 3.38+
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Fonts**: google_fonts (Inter)

## 📄 License

Private - KitaHack 2026 Submission
