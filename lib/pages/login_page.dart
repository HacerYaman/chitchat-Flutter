import 'package:chitchat/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController= TextEditingController();
  final passwordController= TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset("lib/assets/ccicon.png", width: 100, height: 100,),
              Text("Welcome back you\'ve been missed! ❤️",
                style: TextStyle(
                  fontSize: 16,
                ),),
              MyTextField(controller: emailController, hintText: "email", obscureText: false),
            ],
          ),
        ),
      ),
    );
  }
}
