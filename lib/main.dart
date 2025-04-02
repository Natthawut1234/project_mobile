import 'package:flutter/material.dart';
import 'package:project/pages/home_screen.dart';
import 'package:project/pages/login.dart';
import 'package:project/pages/splash_screen.dart';
import 'package:project/provider/order_history_provider.dart';
import 'package:project/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/list_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ListMenu()), // ✅ เพิ่ม Provider
        ChangeNotifierProvider(
            create: (context) => OrderHistoryProvider()), // ✅ เพิ่ม Provider
        ChangeNotifierProvider(
            create: (context) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Cafe POS System',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
            nextScreen: _isLoggedIn ? const HomeScreen() : const LoginScreen()),
      ),
    );
  }
}
