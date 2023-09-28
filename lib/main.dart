import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/constants/ColorProvider.dart';
import 'package:mobile/cubit/auth_cubit/auth_cubit.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/pages/postcards_page/postcards_page.dart';
import 'package:mobile/repositories/auth_repository.dart';
import 'package:mobile/repositories/postcard_repository.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/repositories/user_repository.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final token = await SecureStorageRepository.read(key: 'token');
  await ColorProvider.loadColors();
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.token});

  final String? token;

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = false;
    if (token != null) {
      if (!JwtDecoder.isExpired(token!)) {
        isAuthenticated = true;
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthRepository()),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(UserRepository()),
        ),
        BlocProvider<PostcardCubit>(
          create: (context) => PostcardCubit(PostcardRepository()),
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
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: ColorProvider.getColor('primary', theme: 'light'),
            onPrimary: Colors.black,
            secondary: ColorProvider.getColor('secondary', theme: 'light'),
            onSecondary: Colors.black,
            primaryContainer: Colors.black,
            secondaryContainer: ColorProvider.getColor('primary', theme: 'light'),
            onSecondaryContainer: ColorProvider.getColor('onSecondaryContainer', theme: 'light'),
            error: Colors.red,
            onError: Colors.white,
            background: ColorProvider.getColor('background', theme: 'light'),
            onBackground: ColorProvider.getColor('onBackground', theme: 'light'),
            surface: ColorProvider.getColor('surface', theme: 'light'),
            onSurface: ColorProvider.getColor('onSecondaryContainer', theme: 'light'),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: ColorProvider.getColor('primary', theme: 'dark'),
            onPrimary: Colors.white,
            secondary: ColorProvider.getColor('secondary', theme: 'dark'),
            onSecondary: Colors.white,
            primaryContainer: ColorProvider.getColor('secondary', theme: 'dark'),
            secondaryContainer: ColorProvider.getColor('secondary', theme: 'dark'),
            onSecondaryContainer: ColorProvider.getColor('onSecondaryContainer', theme: 'dark'),
            error: Colors.red,
            onError: Colors.white,
            background: ColorProvider.getColor('background', theme: 'dark'),
            onBackground: ColorProvider.getColor('onBackground', theme: 'dark'),
            surface: ColorProvider.getColor('surface', theme: 'dark'),
            onSurface: Colors.white,
          ),
        ),
        themeMode: ThemeMode.system,
        home: isAuthenticated ? const PostcardsPage() : const LoginPage(),
      ),
    );
  }
}
