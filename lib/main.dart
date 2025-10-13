import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 👇 Add this import after running `flutterfire configure`
import 'firebase_options.dart';

import 'Get_Started.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Proper Firebase initialization (fixes web blank screen)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final isDark = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn, isDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isDark;
  const MyApp({super.key, required this.isLoggedIn, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void toggleTheme(bool value) async {
    setState(() => _isDark = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0E4839),
        fontFamily: "Poppins",
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0E4839),
        fontFamily: "Poppins",
        scaffoldBackgroundColor: const Color(0xFF181A20),
        cardColor: const Color(0xFF23262F),
        dialogBackgroundColor: const Color(0xFF23262F),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF23262F)),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: widget.isLoggedIn
          ? HomePage(onThemeChanged: toggleTheme, isDark: _isDark)
          : const Started(),
    );
  }
}
