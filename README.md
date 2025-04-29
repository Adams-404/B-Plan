# 📘 B-Plan — Minimalist Daily Planner App

**B-Plan** is a sleek, clutter-free task management app designed to help you stay focused and organized. Built with **Flutter**, B-Plan aims to provide a simple, fast, and reliable cross-platform task management experience.

Whether you're planning your day, tracking completed tasks, or just need a lightweight way to stay on top of things, B-Plan is built to fit seamlessly into your lifestyle.

---

## ✨ Features

- ✅ **Add & Manage Daily Tasks** — Quickly add, update, and delete tasks.
- 📆 **Today’s View** — Stay focused with a clean list of tasks scheduled for today.
- 📊 **Task History** — Track your productivity by viewing completed tasks.
- ☁️ **Data Persistence** — Your tasks are saved locally on your device.
- 🧭 **Tab-Based Navigation** — Simple and intuitive layout to switch between screens.

---

## 📦 Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Framework    | Flutter            |
| Language     | Dart               |
| State Management | Provider |
| Data Storage | (Needs Implementation) |
| Styling      | Flutter built-in widgets |

---

## 📱 Screenshots

> *(Add screenshots here — e.g., home screen, today view, task history)*

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- A supported IDE (Android Studio, VS Code, etc.) with the Flutter plugin.

---

### 🔧 Installation

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd b-plan
   ```

2. **Get the dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```
   (Optionally, specify target device/platform, e.g., `flutter run -d chrome`)

---

## 🗂️ Folder Structure

```
/b-plan
├── android/
├── lib/
│   ├── models/
│   │   └── task.dart
│   ├── providers/
│   │   └── task_provider.dart
│   ├── screens/
│   │   ├── all_tasks_screen.dart
│   │   ├── history_screen.dart
│   │   ├── settings_screen.dart
│   │   └── today_screen.dart
│   ├── widgets/
│   │   ├── add_task_modal.dart
│   │   └── task_card.dart
│   └── main.dart
├── test/
├── web/
├── pubspec.yaml
└── README.md
```

---

## 📌 Roadmap

- [x] Add task
- [x] View today’s tasks
- [x] View task history
- [ ] Implement Data Storage (e.g., local database, cloud sync)
- [ ] User Authentication
- [ ] Push notifications
- [ ] Calendar integration
- [ ] AI-generated task suggestions

---

## 🤝 Contributing

Pull requests are welcome! To contribute:

1. Fork the repo
2. Create a feature branch:
   ```bash
   git checkout -b feature/my-feature
   ```
3. Commit your changes
4. Push and open a PR

---

## 🛡 License

MIT License © 2025 Muhammad Adamu Aliyu

---

## 👨‍💻 Author

**Muhammad Adamu Aliyu (a.k.a. Sudo)**  
🔗 [LinkedIn](https://www.linkedin.com/in/muhammad-adamu-aliyu-6020432a0) • 🌐 [Portfolio](#)

---

## 🧠 Philosophy

> *Plan simply. Execute clearly.*  
B-Plan is designed to reduce friction between your intentions and your actions — no distractions, no bloat. Just your day, your way.
