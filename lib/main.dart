import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chitchat/firebase_options.dart';
import 'package:chitchat/services/auth/auth_gate.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Poppins fontunu varsayılan olarak ayarlayın
      ),
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset(
              "lib/assets/ccicon.png"
            ),
            splashIconSize: 200,
            nextScreen: AuthGate(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }
}
