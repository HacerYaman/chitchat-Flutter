import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chitchat/firebase_options.dart';
import 'package:chitchat/pages/onboarding_page.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/services/auth/auth_gate.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'api/firebase_api.dart';

final navigatorKey= GlobalKey<NavigatorState>(); //for navigation purposses


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final User? currentUser = _auth.currentUser;
    final bool isLogged = currentUser != null;

    return GetMaterialApp(
        routes: {
          '/profile': (context) => ProfilePage(),
          // Add more routes here
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset("lib/assets/ccicon.png"),
            splashIconSize: 200,
            nextScreen: isLogged ? AuthGate() : OnboardingPage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }
}
