# 🥗 NutriScan — AI Food & Nutrition Tracker

<p align="center">
  <img src="assets/images/logo.png" width="140" alt="NutriScan Logo" />
</p>

<p align="center">
  <b>NutriScan</b> is an AI-powered Flutter application that makes nutrition tracking effortless. Simply scan your meals to receive detailed nutritional insights, personalized meal recommendations, and interactive analytics—all designed to help you make healthier food choices.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.19+-02569B?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart" />
  <img src="https://img.shields.io/badge/Firebase-Cloud-FFCA28?style=for-the-badge&logo=firebase" />
  <img src="https://img.shields.io/badge/AI-Groq-FF4F00?style=for-the-badge" />
</p>

---

# 📱 Download APK

Try the latest Android version:

**📥 APK Download:**  
https://drive.google.com/drive/folders/1Fe-NJ_TS3Lr9PG_Aczqvw053XbIlyaYS?usp=sharing

> Replace this with your actual APK release URL if different.

---

# ✨ Features

## 📸 AI Food Recognition

- Scan food using your camera or gallery
- AI automatically identifies food items
- Estimates:
  - Calories
  - Protein
  - Carbohydrates
  - Fat
  - Fiber
  - Sugar
- Generates a Health Score (0–100)
- Displays health benefits and dietary warnings

---

## 📊 Nutrition Analytics

Monitor your eating habits with interactive charts.

- Weekly, Monthly & Yearly statistics
- Calories tracking
- Protein tracking
- Carbohydrate tracking
- Fat tracking
- Beautiful charts powered by **fl_chart**
- Detailed nutritional insights

---

## 🥗 AI Meal Planner

Generate personalized meal plans based on:

- Daily calorie goals
- Dietary preferences
- Macronutrient targets
- Health objectives

---

## 📚 Food History

- Complete food log
- Search meals instantly
- Sort by:
  - Date
  - Calories
  - Health Score

---

## 📄 Export Reports

Generate professional PDF nutrition reports containing:

- Food history
- Nutrition summary
- Daily statistics
- Health scores

---

## 🌍 Multi-Language Support

Supports:

- 🇺🇸 English
- 🇧🇩 Bengali

with complete localization.

---

## 🎨 Beautiful UI

- Material Design 3
- Light Theme
- Dark Theme
- Responsive layouts
- Smooth animations

---

## ☁️ Cloud Sync

Powered by Firebase:

- Authentication
- Cloud Firestore
- Secure cloud backup
- Cross-device synchronization

---

# 🛠 Tech Stack

| Category | Technology |
|-----------|------------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| AI Models | Groq (Qwen & Llama) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Networking | Dio |
| Charts | fl_chart |
| PDF | pdf & printing |

---

# 🧠 AI Models

### Vision Analysis

- **Qwen 3.6 27B**
- Food recognition
- Nutrition estimation
- Health scoring

### Meal Planning

- **Llama 3.3 70B**
- Personalized meal generation
- Dietary recommendations

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK 3.19+
- Dart SDK
- Android Studio / VS Code
- Groq API Key
- Firebase Project

---

## Clone Repository

```bash
git clone https://github.com/subhash-varun/nutriscan.git
cd nutriscan
```

---

## Configure Environment

Create:

```text
assets/.env
```

Add:

```env
GROQ_API_KEY=your_api_key_here
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Run

```bash
flutter run
```

---

# 📂 Project Structure

```text
lib/
├── config/
├── models/
├── providers/
├── screens/
├── services/
├── utils/
└── widgets/
```

---

# 📸 Screenshots

> Add application screenshots here.

| Home | AI Scan | Analytics | Meal Plan |
|------|---------|------------|-----------|
| Screenshot | Screenshot | Screenshot | Screenshot |

---

# 🔮 Roadmap

- ✅ AI Food Detection
- ✅ Nutrition Analytics
- ✅ Meal Planner
- ✅ PDF Reports
- ✅ Firebase Sync
- 🔄 Barcode Scanner
- 🔄 Water Intake Tracker
- 🔄 Exercise Tracking
- 🔄 Wearable Device Integration

---

# 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

# 📄 License

Distributed under the MIT License.

See the `LICENSE` file for more information.

---

# 👨‍💻 Developer

**Subhash Varun**

GitHub: https://github.com/subhash-varun

---

<p align="center">
⭐ If you found this project helpful, consider giving it a star!
</p>
