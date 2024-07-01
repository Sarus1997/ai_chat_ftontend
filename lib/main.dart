import 'package:flutter/material.dart';
import 'package:ai_chat_frontend/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  void toggleTheme(bool isDark) {
    setState(() {
      isDarkTheme = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Project',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(toggleTheme: toggleTheme),
    );
  }
}
