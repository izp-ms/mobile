import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/cubit/auth_cubit/auth_cubit.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/repositories/auth_repository/auth_repository.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthRepository()),
        )
      ],
      child: MaterialApp(
        title: 'postcardia',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
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
            background: Color(0xFFE3E6E7),
            onBackground: Color(0xFFC4CDCD),
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
            onBackground: Color(0xFF1C1C1C),
            surface: Color(0xFF464646),
            onSurface: Colors.white,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const LoginPage(),
      ),
    );
  }
}
