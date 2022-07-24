import 'package:flutter/material.dart';

const tutterColor = Color(0xFF65abc1);
const menuColor = Color(0xFF232A31);
const backgroundColor = Color(0xFF1A1C1E);

final tutterMaterialColor = MaterialColor(tutterColor.value, const {
    50: Color(0xFFEDF5F8),
    100: Color(0xFFD1E6EC),
    200: Color(0xFFB2D5E0),
    300: Color(0xFF93C4D4),
    400: Color(0xFF7CB8CA),
    500: Color(0xFF65ABC1),
    600: Color(0xFF5DA4BB),
    700: Color(0xFF539AB3),
    800: Color(0xFF4991AB),
    900: Color(0xFF37809E),
});

final themeData = ThemeData(
    primaryColor: tutterColor,
    primarySwatch: tutterMaterialColor,
    scaffoldBackgroundColor: backgroundColor,
    brightness: Brightness.dark,
    backgroundColor: backgroundColor,
);
