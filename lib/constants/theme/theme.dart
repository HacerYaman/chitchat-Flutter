import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.amber,  //ana renk sarı ya da gri
    secondary: Colors.amber.shade300,   //mesaj kutusu gönderilen
    tertiary: Colors.black, //buton
    surface: Colors.amber, //profile section

    //navbar için renk
    onTertiary: Colors.white,



  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.dark(
    background: Colors.black45,
    primary: Colors.blueGrey.shade300,
    secondary: Colors.amber.shade200,
    tertiary: Colors.blueGrey.shade300, //buton
    surface: Colors.blueGrey.shade300,  //profile section

    onTertiary: Colors.blueGrey.shade300,


  ),
);
