import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.blueGrey[600],
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColor.primaryColors, background: Colors.grey),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
        ),

        textTheme: TextTheme(
          displaySmall: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
          displayMedium: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
          displayLarge: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
          labelLarge: const TextStyle(color: CustomColor.primaryColors, fontWeight: FontWeight.bold, fontSize: 60, height: 0.0),
          labelMedium: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 0.0),
          headlineMedium: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 0.0),
          headlineSmall: const TextStyle(fontSize: 10, color: Colors.white),
          labelSmall: TextStyle(color: Colors.grey[100], fontSize: 12.0, height: 0.0),
          titleLarge: const TextStyle(color: CustomColor.primaryColors, fontSize: 18, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis, height: 0.0),
          titleMedium: TextStyle(color: Colors.grey[700], fontSize: 10, overflow: TextOverflow.ellipsis, height: 0.0),
          bodyLarge: const TextStyle(color: CustomColor.secondaryTextColor, fontSize: 60, fontWeight: FontWeight.bold, height: 0.0,),
          titleSmall: const TextStyle(color: CustomColor.secondaryColor, fontSize: 10, height: 0.0),
          bodyMedium: const TextStyle(color: CustomColor.secondaryTextColor, fontSize: 30, fontWeight: FontWeight.w500),
          bodySmall: const TextStyle(color: CustomColor.secondaryColor, fontSize: 24, height: 0),
          headlineLarge :const TextStyle(color: CustomColor.secondaryColor, fontSize: 14, height: 0.0),
        )
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.blueGrey[900],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
        ),

        textTheme: TextTheme(
            titleLarge: const TextStyle(color: CustomColor.primaryColors, fontSize: 18, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis, height: 0.0),
            titleMedium: TextStyle(color: Colors.grey[700], fontSize: 10, overflow: TextOverflow.ellipsis, height: 0.0))
    );
  }
}

class CustomColor {
  static const primaryColors = Color(0xFFE20F00); //red
  static const secondaryColor = Color(0xFF878787);
  static const greenColor = Color(0xFF4CAF50);
  static const loginButtonColor = Color(0xFF376688);
  static const secondaryTextColor = Color(0xFF1B2031);
}
