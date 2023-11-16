import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chitchat/constants/theme/theme_provider.dart';
import 'package:chitchat/firebase_options.dart';
import 'package:chitchat/pages/onboarding_page.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/pages/update_profile_page.dart';
import 'package:chitchat/services/auth/auth_gate.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:chitchat/services/local_push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'api/firebase_api.dart';

final navigatorKey = GlobalKey<NavigatorState>(); //for navigation purposses

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  LocalNotificationService.initialize();

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
    ],
    child: MyApp(
      themeProvider: themeProvider,
    ),
  ));
}

class MyApp extends StatelessWidget {

  ThemeProvider themeProvider;

  MyApp({Key? key, required this.themeProvider}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    userService.fetchCurrentUser();

    final User? currentUser = _auth.currentUser;
    final bool isLogged = currentUser != null;

    return GetMaterialApp(
      routes: {
        '/profile': (context) => ProfilePage(),
        // Add more routes here
      },
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AnimatedSplashScreen(
          duration: 2000,
          splash: Image.asset("lib/assets/ccicon.png"),
          splashIconSize: 200,
          nextScreen: isLogged ? const AuthGate() : const OnboardingPage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white),
    );
  }
}
