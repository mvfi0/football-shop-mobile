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

## Assignment 7

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
```
### 6. Hot Reload vs Hot Restart

| Hot Reload | Hot Restart |
|-----------|-------------|
| Keeps the app state | Resets the app state |
| Reloads only changed code and UI | Rebuilds the entire app from scratch |
| Very fast development tool | Slower than hot reload |
| Used mainly for UI changes | Used when app logic or state is corrupted |

**Simple rule:**  
- **UI change?** → *Hot Reload*  
- **Logic/state reset needed?** → *Hot Restart*

## Assignment 8
### 1.`Navigator.push()` vs. `Navigator.pushReplacement()`
In Flutter, `Navigator` manages a stack of "routes" (pages). The key difference between `push` and `pushReplacement` is how they interact with this stack.
->`Navigator.push(context, ...)`:

 - **What it does:** This method "pushes" a new route onto the top of the navigation stack.
 - **User Experience:** The user sees a new page slide in. The previous page is kept in the stack, and an "app bar" will automatically show a "back" button to return to it.
 - **Best Use:** Use this when you are navigating to a "detail" or "secondary" page and expect the user to return.
 - **Our App:** We use `push()` when tapping the **"Create Product"** button on the `MenuScreen`. This opens the `ShopFormPage`, but we fully expect the user to go back to the menu after saving or canceling.
 ```dart
 // From lib/menu.dart
onPressed: () {
  Navigator.push( // Adds ShopFormPage to the stack
    context,
    MaterialPageRoute(builder: (context) => const ShopFormPage()),
  );
},
```
-> `Navigator.pushReplacement(context, ...)`:
 - **What it does:** This method also pushes a new route, but it _disposes_ (removes) the current route from the stack immediately after.
 - **User Experience:** The user sees a new page, but there is no "back" button to return to the page they just left (because it no longer exists in the stack).
 - **Best Use:** Use this for one-way navigation, like after a login (replacing the Login Page with the Home Page) or when switching main sections of an app (like in our drawer).
 - **Our App:** We use `pushReplacement()` in our `LeftDrawer` for the **"Home"** button. If the user is on the "Add Product" form and clicks "Home," we _replace_ the form with the `MenuScreen`. We don't want them to press "back" and accidentally return to the form they just navigated away from.
 ```dart
 // From lib/left_drawer.dart
onTap: () {
  Navigator.pushReplacement( // Replaces the current page with MenuScreen
    context,
    MaterialPageRoute(builder: (context) => const MenuScreen()),
  );
},
```
### 2. Hierarchical Widgets for Consistent Structure
`Scaffold`, `AppBar`, and `Drawer` are fundamental building blocks for creating a consistent look and feel across an application.
 - **`Scaffold`:** This is the main "skeleton" widget for a page. It provides a pre-defined layout structure with named slots for common elements like an `appBar`, `body`, and `drawer`. By using a `Scaffold` as the root of every page, we guarantee they all share the same basic layout.
 - **`AppBar`:** This widget is placed in the `Scaffold.appBar` slot. It creates the bar at the top of the screen. In our app, we styled it consistently with a `flexibleSpace` gradient and our custom `AnimatedGradientText` widget in the `title` property. This ensures our "Sports Universe" branding is present on every page.
 - **`Drawer`:** This widget is placed in the `Scaffold.drawer` slot. In our app, we created a single, reusable widget file (`lib/left_drawer.dart`) and passed an instance of it (`const LeftDrawer()`) to the `drawer` property of _every_ `Scaffold`. This is the most important part: by reusing the exact same drawer widget, we ensure that the navigation options are identical, no matter what page the user is on.
```dart
// From lib/menu.dart
@override
Widget build(BuildContext context) {
  return Scaffold( // 1. The main page structure
    appBar: AppBar( // 2. The top bar with title and gradient
      title: const AnimatedGradientText(), 
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(...),
        ),
      ),
    ),
    drawer: const LeftDrawer(), // 3. The slide-out navigation menu
    body: Center( // 4. The main content of the page
      // ... buttons ...
    ),
  );
}
```
### 3. Advantages of Layout Widgets in Forms
When building forms, layout widgets are essential for creating a clean, usable, and error-free user interface.
 - `Padding`:
		- **Advantage:** `Padding` creates "breathing room" or whitespace around its child. In forms, this is critical for preventing text fields and buttons from touching the edges of the screen, which looks unprofessional and can be hard to use. It's the simplest way to improve a UI's visual clarity.
		- **Example:** In our `ShopFormPage`, we wrapped the `SingleChildScrollView`'s child `Column` with `padding: const EdgeInsets.all(16.0)`. This indents the entire form from the screen's edges.
 - `SingleChildScrollView`:
		 - **Advantage:** Its sole purpose is to make its child scrollable. When a user taps on a `TextFormField`, the on-screen keyboard appears and often covers the bottom half of the screen. Without a scrolling widget, this would cause a "RenderFlex overflow" error and block the user from seeing what they are typing.
		 - **Example:** We use it as the direct child of our `Form` in `lib/shop_form.dart` to ensure the whole form can be scrolled when the keyboard is open.
- `ListView`:
		- **Advantage:** `ListView` is perfect for displaying a scrollable list of items, especially when the number of items is unknown. Unlike a `Column`, it automatically handles scrolling.
		- **Example:** We use it inside our `lib/left_drawer.dart` to display the list of navigation options ("Home", "Add Product"). If we added 10 more links, the drawer would automatically become scrollable.

### 4. Setting a Consistent Color Theme
We set a consistent color theme for the _entire app_ inside the `MaterialApp` widget in `lib/main.dart`. By defining a `ThemeData` object, we can set default styles for everything, from the background color to `AppBar`s and forms. This is much better than styling each widget individually.
In our app, I did the following:

 1. Set `brightness: Brightness.dark` to make the app dark-themed.
 2. Set `scaffoldBackgroundColor` to our "galaxy" purple (`0xFF110025`).
 3. Defined a `colorScheme` to set the primary (purple) and secondary (fuchsia) colors
 4. Created a global `inputDecorationTheme` to style every `TextFormField` in the app with our dark, semi-transparent background and fuchsia-colored focused border.
```dart
// From lib/main.dart
class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Universe',
      theme: ThemeData( // This is where the magic happens
        // --- 2. SET DARK GALAXY THEME ---
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6d28d9), // Purple
        scaffoldBackgroundColor: const Color(0xFF110025), // Dark purple bg
        
        // Define a color scheme for the dark theme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFa855f7), // Purple
          secondary: Color(0xFFd946ef), // Fuchsia
          background: Color(0xFF110025), // Dark purple bg
          onBackground: Color(0xFFf3e8ff), // Light text
          error: Colors.redAccent,
        ),
        
        // Style TextFormFields globally
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(8.0),
             borderSide: const BorderSide(color: Color(0xFFd946ef)), // Fuchsia
          ),
          labelStyle: const TextStyle(color: Color(0xFFf3e8ff)),
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
```

## Assignment 9
### 1. Why do we need to create a Dart model when fetching/sending JSON data?
When interacting with JSON data, using a Dart model is significantly more reliable than directly working with `Map<String, dynamic>`. Several advantages include:

#### a. Type Safety  
Models provide strict typing, reducing runtime errors caused by incorrect data types or misspelled keys. Raw Maps cannot ensure this.

#### b. Null Safety  
Models help enforce which fields are required and which are optional, preventing crashes caused by unexpected null values.

#### c. Maintainability and Scalability  
Models act as a central specification of the data structure. As the API grows, modifying the model is far easier than manually updating multiple Map-based implementations.

#### d. Validation  
Models can implement validation logic before data is used, something that is not practical with raw Maps.

#### Consequences of using `Map<String, dynamic>` directly
- **Runtime errors**: missing keys or wrong types are only discovered at runtime.
- **Poor readability**: intent is less clear than typed fields.
- **Harder refactoring**: changes in the API must be tracked manually everywhere.
- **Weaker null-safety guarantees**: more boilerplate checks or potential crashes.

---

### 2. What is the purpose of the `http` and `CookieRequest` packages in this assignment?

#### `http` package
- A general-purpose HTTP client.
- Stateless: does not store cookies automatically.
- Best for simple, unauthenticated requests or fetch-only APIs.

#### `CookieRequest` (from `pbp_django_auth`)
- Designed to work with Django's session-based authentication.
- Automatically stores and sends cookies (session cookie, CSRF token).
- Provides helpers for login/logout and persistent authenticated requests.
- Necessary when endpoints rely on Django sessions (login-required views).

**Difference (summary)**  
- `http` = generic HTTP client (no cookie/session management).  
- `CookieRequest` = session-aware client that manages cookies/CSRF for Django.

---

### 3. Why the `CookieRequest` instance needs to be shared across the app
`CookieRequest` stores the authentication cookies and CSRF token that represent the user's session. If you instantiate it locally per widget or per request:
- the session state will not be shared,
- login state would be lost between pages,
- authenticated endpoints would fail.

By providing a single `CookieRequest` at the application root (for example with `Provider`), every widget that needs to call authenticated endpoints uses the same session data:

```dart
Provider(create: (_) => CookieRequest(), child: MyApp())
```
This mirrors how a browser persists cookies across tabs and requests.

### 4. Connectivity configuration required for Flutter to communicate with Django

Flutter (especially Flutter Web and Android emulator) requires several configuration steps to communicate properly with a Django backend. Below are all required settings and why they matter.

---

#### **a. ALLOWED_HOSTS**

When running Django locally, we must explicitly allow incoming requests.  
Flutter Web or Android Emulator does **not** use the same hostname as the Django backend.

For example:

- **Flutter Web** uses a random port like `http://localhost:57766/`.
- **Android Emulator** uses `10.0.2.2` to access the host machine.

So, in `settings.py`:

```python
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "10.0.2.2",
]
```
If this is not set correctly, Django will reject every request with 400 Bad Request (Invalid Host Header).

#### **b. CORS Configuration**
Flutter Web sends cross-origin requests because it is served from a different port.
Django must explicitly allow this.
Example using `django-cors-headers`:
```python
CORS_ALLOW_ALL_ORIGINS = True
```
or more strict:
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:57766",
    "http://localhost:5000",
]
```
Without correct CORS settings:

- Requests from Flutter Web will be blocked.
- Cookies may not be included.
- Login/logout may silently fail.

#### **c. Cookie & SameSite / CSRF settings**
Django uses CSRF and session cookies to maintain authentication.
Flutter must receive and send these cookies on every request.

In `settings.py`, you generally need:
```python
SESSION_COOKIE_SAMESITE = "Lax"
CSRF_COOKIE_SAMESITE = "Lax"
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False
```
If too strict (e.g., `SameSite=Strict`), cookies are not sent, causing:
- Login works once, but subsequent API calls act as if you're logged out.
- POST requests fail CSRF validation.

#### **d. Android requires Internet permission**
For Android builds, add this inside `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
Without this:
- Your Flutter app will never reach the Django backend.
- All network calls silently fail.

#### **e. Summary of what breaks if these settings are incorrect**
| Misconfiguration                      | Result                                       |
| ------------------------------------- | -------------------------------------------- |
| Missing `10.0.2.2` in `ALLOWED_HOSTS` | Emulator receives 400 errors                 |
| CORS disabled                         | Flutter Web blocked from making requests     |
| Strict SameSite/CSRF settings         | Login works but subsequent calls fail        |
| Missing Android internet permission   | All networking fails                         |
| HTTPS settings incorrectly forced     | Cookies not sent over HTTP                   |
| Incorrect host in API URLs            | Requests go to wrong server or fail silently |

Together, these configurations ensure stable communication between Flutter and Django across all platforms.

#### **5. Describe the data transmission mechanism — from user input to being displayed in Flutter**
The process from user input → Django backend → Flutter UI can be summarized in steps:
1. Users enter data

The user fills a form (e.g., adding a product) using Flutter widgets:
- `TextFormField`
- `DropdownButtonFormField`
- `CheckboxListTile`
2. Flutter validates the input

Using validators in the `Form` widget:
```dart
if (_formKey.currentState!.validate()) {
    // proceed
}
```
3. Flutter sends the data to Django

Using `request.postJson()`:
```dart
final response = await request.postJson(
  "http://localhost:8000/create-product/",
  jsonEncode({
    "name": _nameController.text,
    "price": int.parse(_priceController.text),
    ...
  }),
);
```
Cookies stored in `CookieRequest` ensure the request is **authenticated**.

4. Django receives the data

Django view:
- Validates the JSON
- Saves the product in the database
- Returns a JSON response
5. Flutter receives the response

`response` is a JSON object from Django:
```json
{
  "status": "success",
  "message": "Product created"
}
```
6. UI updates

Flutter shows:
- Snackbars
- Navigation to success pages
- Updated product list retrieved from Django

7. Product list displays updated items

Fetching from `/json/`, parsing into Dart models, and rendering using:
```dart
ListView.builder(...)
```

### 6. Explain the authentication mechanism in Flutter ↔ Django
The mechanism involves three endpoints: login, register, logout.

#### **a. Registration**
Flutter sends:
```json
{
  "username": "...",
  "password": "...",
}
```
Django creates a user and replies with `"status": true`.

#### **b. Login**
Flutter uses:
```dart
final response = await request.login(
  "http://localhost:8000/auth/login/",
  {"username": username, "password": password},
);
```
Django:
- Verifies credentials
- Creates a session
- Sends back session cookies

`CookieRequest` automatically stores:
- sessionid
- csrftoken

#### **c. Authenticated requests**
Every `request.get()` and `request.postJson()` automatically includes cookies.

Django checks:
- If the session is valid
- If the user is logged in
- Grants access to authenticated endpoints

#### **d. Logout**
Flutter:
```dart
await request.logout("http://localhost:8000/auth/logout/");
```
Django destroys the session.\
Flutter removes the cookies from `CookieRequest`.

#### **e. Menu logic (showing different pages depending on login state)**
After login:
- The session stays valid
- Drawer buttons (All Products, My Products, Logout) are now active
- Protected routes now work

If session expired:
- Protected endpoints will return 403/401
- User is redirected to login

### 7. How you implemented the checklist step-by-step
This section justifies the implementation process (not a tutorial).

1. Ensured Django Deployment Works
- Started Django normally
- Tested endpoints in browser (/json/, /auth/login/)
- Ensured no HTML errors returned for JSON endpoints

2. Implemented Account Registration
- Built registration form in Flutter
- Sent POST request to Django
- Django created user account
- Displayed success snackbar

3. Created Login Page
- Login form using TextFormField
- Submit credentials via CookieRequest.login()
- Stored session cookies for later use

4. Integrated Django Authentication
- Wrapped app in:
```dart
Provider(create: (_) => CookieRequest(), child: MyApp())
```
- Ensured all authenticated endpoints worked

5. Created Dart model
- Generated `ProductEntry` model
- Ensured Dart structure matches Django’s model
- Used `.fromJson()` parsing for product list and detail screens

6. Built All Products Page
- Fetched list via `CookieRequest.get()`
- Parsed into model list
- Rendered using `ProductEntryCard`

7. Built Detail Page
- Individual product info displayed
- Added share button and cart UI placeholders

8. Built Create Product Form
- All fields implemented: name, price, description, stock, rating
- Submit data to Django
- Showed success dialog and reset form

9. Implemented Filtering (“My Products”)
- Used `/auth/whoami/` to get `user id`
- Filtered items where `fields.user == userid`
- Displayed in separate page: MyProductsScreen

10. Implemented Logout
- Added logout item in drawer
- Called `request.logout()`
- Navigated back to login screen using `pushAndRemoveUntil`