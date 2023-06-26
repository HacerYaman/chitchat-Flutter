import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController= TextEditingController();
  final usernameController= TextEditingController();
  final passwordController= TextEditingController();
  final confirmPasswordController= TextEditingController();

  void signUp(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15,),
                Image.asset("lib/assets/ccicon.png", width: 100, height: 100,),
                SizedBox(height: 50,),
                Text("Let's create an account for you! ❤️",
                  style: TextStyle(
                    fontSize: 16,
                  ),),
                SizedBox(height: 15),
                MyTextField(controller: usernameController, hintText: "user name", obscureText: false),
                SizedBox(height: 15,),
                MyTextField(controller: emailController, hintText: "email", obscureText: false),
                SizedBox(height: 15,),
                MyTextField(controller: passwordController, hintText: "password", obscureText: true),
                SizedBox(height: 15,),
                MyTextField(controller: confirmPasswordController, hintText: "confirm password", obscureText: true),
                SizedBox(height: 15,),
                MyButton(buttonText: "Sign Up", onTap: signUp,),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?", style: TextStyle(),),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign in", style: TextStyle(fontWeight: FontWeight.bold, ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
