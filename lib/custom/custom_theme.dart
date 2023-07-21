import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData customTheme = ThemeData(
    /* 
      Color Section
     */
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(251, 18, 16, 1),
    ),
    useMaterial3: true,

    /* 
      Text Section
     */
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      bodySmall: TextStyle(fontSize: 14),
    ),
    /* 
      Input Area
     */
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      activeIndicatorBorder: const BorderSide(
        color: Colors.yellow,
      ),
      focusColor: Colors.yellow,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(color: Colors.purple),
      ),
    ),

    /* 
      Button Section
     */
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
  );
}
