# 🥗 NutriScan — AI Food & Nutrition Tracker

<p align="center">
  <img src="assets/images/logo.png" width="120" alt="NutriScan Logo" />
</p>

<p align="center">
  <b>NutriScan</b> is a state-of-the-art Flutter mobile application designed to simplify diet tracking, food logging, and nutrition analysis using advanced AI vision models and high-density interactive analytics.
</p>

---

## ✨ Features

- **📸 Instant AI Food Scanning**: Capture or upload photos of your meals to automatically detect food items, calculate calories, macronutrients (Protein, Carbs, Fat, Fiber, Sugar), generate a Health Score (0-100), and receive actionable health benefits and warnings.
- **📊 High-Density Nutrition Analytics**:
  - Interactive **Period Filtering**: View nutrition trends across **Week**, **Month**, and **Year**.
  - **Metric Selectors**: Toggle seamlessly between Calories, Protein, Carbs, and Fat.
  - **Macronutrient Charts & Insights**: Powered by `fl_chart` for clean data visualization.
- **🥦 AI Meal Plan Generator**: Generate personalized daily and weekly meal plans based on calorie goals, dietary preferences, and target macro splits.
- **📜 Food History & Search**: Sleek, high-density food log list with real-time text search and sorting by date, calorie content, or health score.
- **📄 PDF Nutrition Reports**: Export clean, professional PDF reports of your logged food history.
- **🌐 Multi-Language Support**: Full internationalization for **English** and **Bengali** with font family customization.
- **🌓 Modern Dark & Light Mode**: Custom design system supporting sleek dark mode and vibrant light mode UI.
- **☁️ Cloud Backup & Auth**: Firebase authentication and cloud synchronization to keep your nutrition data safe across devices.

---

## 🛠️ Tech Stack & Architecture

- **Core**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `Provider` (`FoodProvider`, `ThemeProvider`, `LanguageProvider`, `MealPlanProvider`, `CloudBackupProvider`)
- **AI Engine**: 
  - Vision: **Groq API** (`qwen/qwen3.6-27b`)
  - Text & Meal Plans: **Groq API** (`llama-3.3-70b-versatile`)
- **Data Visualization**: `fl_chart`
- **Database & Auth**: Firebase Auth & Cloud Firestore
- **Networking**: `dio`
- **PDF Generation**: `pdf`, `printing`

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio or VS Code with Flutter extensions
- A valid **Groq API Key** (Get one at [console.groq.com](https://console.groq.com))

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/subhash-varun/nutriscan.git
   cd nutriscan
   ```

2. **Configure Environment Variables**:
   Create or edit `assets/.env`:
   ```env
   GROQ_API_KEY=your_groq_api_key_here
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── config/             # Color schemes, localizations, API endpoints
├── models/             # Data models (Food, MealPlan, UserProfile, etc.)
├── providers/          # Provider state management controllers
├── screens/            # Application screens (Home, Scanner, Analysis, History, Settings)
├── services/           # AI services (Groq), PDF service, Firebase Auth
├── utils/              # Helper utilities and formatters
└── widgets/            # Reusable UI widgets (Charts, Cards, Dropdowns)
```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
