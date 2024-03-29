import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/constants/ColorProvider.dart';
import 'package:mobile/cubit/admin_cubit/admin_cubit.dart';
import 'package:mobile/cubit/auth_cubit/auth_cubit.dart';
import 'package:mobile/cubit/friends_cubit/all_friends_cubit/all_friends_cubit.dart';
import 'package:mobile/cubit/friends_cubit/followed_by_cubit/followed_by_cubit.dart';
import 'package:mobile/cubit/friends_cubit/following_cubit/following_cubit.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/collect_postcard_cubit/collect_postcard_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/unsent_postcards_cubit/unsent_postcards_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/user_postcards_data_cubit/user_postcards_data_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/pages/postcards_page/postcards_page.dart';
import 'package:mobile/pages/profile_page/profile_page.dart';
import 'package:mobile/providers/admin_provider.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:mobile/services/admin_service.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/collect_postcard_service.dart';
import 'package:mobile/services/postcard_service.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'package:mobile/services/user_service.dart';
import 'package:provider/provider.dart';

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
  final token = await SecureStorageService.read(key: 'token');
  await ColorProvider.loadColors();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.token});

  final String? token;
  final ThemeProvider themeNotifier = ThemeProvider();
  final AdminProvider adminProvider = AdminProvider();

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = false;

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      if (!JwtDecoder.isExpired(token!)) {
        if (decodedToken.containsKey(
                'http://schemas.microsoft.com/ws/2008/06/identity/claims/role') &&
            decodedToken[
                    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ==
                'ADMIN') {
          adminProvider.isAdmin = true;
        }
        isAuthenticated = true;
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => adminProvider,
        ),
      ],
      child: Consumer2(builder: (context, ThemeProvider themeNotifier,
          AdminProvider adminProvider, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(AuthService()),
            ),
            BlocProvider<UserCubit>(
              create: (context) => UserCubit(UserService(), PostcardService()),
            ),
            BlocProvider<CollectPostcardCubit>(
              create: (context) =>
                  CollectPostcardCubit(CollectPostcardService()),
            ),
            BlocProvider<PostcardsDataCubit>(
              create: (context) => PostcardsDataCubit(PostcardService()),
            ),
            BlocProvider<UnsentPostcardsCubit>(
              create: (context) => UnsentPostcardsCubit(PostcardService()),
            ),
            BlocProvider<ReceivedPostcardsCubit>(
              create: (context) => ReceivedPostcardsCubit(PostcardService()),
            ),
            BlocProvider<AdminCubit>(
              create: (context) => AdminCubit(AdminService()),
            ),
            BlocProvider<AllFriendsCubit>(
              create: (context) => AllFriendsCubit(UserService()),
            ),
            BlocProvider<FollowingCubit>(
              create: (context) => FollowingCubit(UserService()),
            ),
            BlocProvider<FollowedByCubit>(
              create: (context) => FollowedByCubit(UserService()),
            ),
            BlocProvider<UserPostcardsDataCubit>(
              create: (context) => UserPostcardsDataCubit(PostcardService()),
            ),
            BlocProvider<FriendsCubit>(
              create: (context) => FriendsCubit(UserService(), PostcardService()),
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
                secondaryContainer:
                    ColorProvider.getColor('primary', theme: 'light'),
                onSecondaryContainer: ColorProvider.getColor(
                    'onSecondaryContainer',
                    theme: 'light'),
                error: Colors.red,
                onError: Colors.white,
                background:
                    ColorProvider.getColor('background', theme: 'light'),
                onBackground:
                    ColorProvider.getColor('onBackground', theme: 'light'),
                surface: ColorProvider.getColor('surface', theme: 'light'),
                onSurface: ColorProvider.getColor('onSecondaryContainer',
                    theme: 'light'),
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
                primaryContainer:
                    ColorProvider.getColor('secondary', theme: 'dark'),
                secondaryContainer:
                    ColorProvider.getColor('secondary', theme: 'dark'),
                onSecondaryContainer: ColorProvider.getColor(
                    'onSecondaryContainer',
                    theme: 'dark'),
                error: Colors.red,
                onError: Colors.white,
                background: ColorProvider.getColor('background', theme: 'dark'),
                onBackground:
                    ColorProvider.getColor('onBackground', theme: 'dark'),
                surface: ColorProvider.getColor('surface', theme: 'dark'),
                onSurface: Colors.white,
              ),
            ),
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: isAuthenticated ? const ProfilePage() : const LoginPage(),
          ),
        );
      }),
    );
  }
}
