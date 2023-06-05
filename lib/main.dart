import 'package:flutter/material.dart';
import 'package:mobile/pages/login_page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posty',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFA6ECFF),
          onPrimary: Colors.black,
          secondary: Color(0xFFC4CDCD),
          onSecondary: Colors.white,
          primaryContainer: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFFE3E6E7),
          onBackground: Colors.white,
          surface: Color(0xFFA6ECFF),
          onSurface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF1C1C1C),
          onPrimary: Color(0xFFA6ECFF),
          secondary: Color(0xFFC4CDCD),
          onSecondary: Colors.white,
          primaryContainer: Color(0xFF1C1C1C),
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF282828),
          onBackground: Colors.white,
          surface: Color(0xFFA6ECFF),
          onSurface: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
