# football_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assignment 1

### 1. What is a **widget tree** in Flutter and how do parent–child relationships work?
A **widget tree** represents the structure of UI elements in a Flutter app.  
Each widget is a node, and widgets can contain other widgets (parent → child).  

- **Parent widgets** control layout and provide data/behavior
- **Child widgets** live inside parents and rely on them for placement and data

Flutter updates only the needed parts of the tree when changes occur, making it efficient.

---

### 2. Widgets used in this project and their functions

| Widget | Function |
|--------|---------|
| `MaterialApp` | Root widget — sets app theme, navigation, title |
| `ThemeData`, `AppBarTheme` | App-wide styling configuration |
| `Scaffold` | Base screen structure (AppBar, body, Snackbars) |
| `AppBar` | Top bar showing the title |
| `Center` | Centers content in screen |
| `Column` | Displays children vertically |
| `SizedBox` | Adds vertical spacing |
| `ElevatedButton.icon` | Button with icon + label |
| `Icon` | Shows Material icons |
| `Text` | Displays text on screen/buttons |
| `SnackBar` | Temporary message bar |
| `ScaffoldMessenger` | Shows snackbars in the Scaffold |

---

### 3. What is the function of the **MaterialApp** widget?
`MaterialApp` initializes the app with Material Design and provides:

- Global theme/styling
- App title
- Navigation system
- Localization support
- Debug configuration

It is usually the **root widget** so all children inherit theme and navigation.

---

### 4. Difference between `StatelessWidget` and `StatefulWidget`

| StatelessWidget | StatefulWidget |
|-----------------|----------------|
| Does not change after built | Can change when state updates |
| UI depends only on inputs | UI depends on internal state |
| Fast and lightweight | Used for interactive UI |
| For static screens/buttons | For forms, counters, animations, etc. |

**In this project:**  
`FootballShopApp` and `MenuScreen` are `StatelessWidget`s.

---

### 5. What is **BuildContext** and why is it important?

`BuildContext` links a widget to its location in the widget tree.  
It allows widgets to:

- Access theme data and parent widgets
- Navigate to new screens
- Show Snackbars / dialogs
- Retrieve inherited data

Example use in this app:

```dart
ScaffoldMessenger.of(context).showSnackBar(...)

### ✅ 6. Hot Reload vs Hot Restart

| Hot Reload | Hot Restart |
|-----------|-------------|
| Keeps the app state | Resets the app state |
| Reloads only changed code and UI | Rebuilds the entire app from scratch |
| Very fast development tool | Slower than hot reload |
| Used mainly for UI changes | Used when app logic or state is corrupted |

**Simple rule:**  
- **UI change?** → *Hot Reload*  
- **Logic/state reset needed?** → *Hot Restart*
