import 'package:flutter/material.dart';
import 'package:mobile/pages/register_page/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFA6ECFF),
          onPrimary: Colors.black,
          secondary: Color(0xFF30535B),
          onSecondary: Colors.black,
          primaryContainer: Colors.black,
          secondaryContainer: Color(0xFFA6ECFF),
          onSecondaryContainer: Color(0xFF1C1C1C),
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFFF2F5F6),
          onBackground: Colors.black,
          surface: Color(0xFFDAE0E0),
          onSurface: Color(0xFF1C1C1C),

        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF1C1C1C),
          onPrimary: Colors.white,
          secondary: Color(0xFFA6ECFF),
          onSecondary: Colors.white,
          primaryContainer: Color(0xFFA6ECFF),
          secondaryContainer: Color(0xFFA6ECFF),
          onSecondaryContainer: Color(0xFF1C1C1C),
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF282828),
          onBackground: Colors.white,
          surface: Color(0xFF1C1C1C),
          onSurface: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const RegisterPage(),
    );
  }
}
