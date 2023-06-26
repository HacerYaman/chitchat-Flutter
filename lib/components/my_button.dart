import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

   final void Function()? onTap;
   final String buttonText;

   MyButton({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Center(
          child: Text(buttonText, style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
          ),),
        ),
      ),

    );
  }
}
