import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    const yellowSeedColor = Color.fromARGB(255, 255, 230, 0);
    const darkBlueSeedColor = Color.fromARGB(255, 0, 79, 143);
    const lightBlueSeedColor = Color.fromARGB(255, 0, 105, 190);

    const textTheme = TextTheme(
      displayLarge: TextStyle(color: yellowSeedColor),
      displayMedium: TextStyle(color: yellowSeedColor),
      displaySmall: TextStyle(color: yellowSeedColor),
      headlineMedium: TextStyle(color: yellowSeedColor),
      headlineSmall: TextStyle(color: yellowSeedColor),
      titleLarge: TextStyle(color: yellowSeedColor),
      bodyLarge: TextStyle(color: yellowSeedColor),
      bodyMedium: TextStyle(color: yellowSeedColor),
      bodySmall: TextStyle(color: yellowSeedColor),
      labelLarge: TextStyle(color: yellowSeedColor),
      titleMedium: TextStyle(color: yellowSeedColor),
      titleSmall: TextStyle(color: yellowSeedColor),
      labelSmall: TextStyle(color: yellowSeedColor),
      headlineLarge: TextStyle(color: yellowSeedColor),
      labelMedium: TextStyle(color: yellowSeedColor),
    );

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: darkBlueSeedColor,
      listTileTheme: const ListTileThemeData(
          iconColor: yellowSeedColor, textColor: yellowSeedColor),
      appBarTheme: const AppBarTheme(
          color: darkBlueSeedColor,
          titleTextStyle: TextStyle(
              color: yellowSeedColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: yellowSeedColor)),
      iconTheme: const IconThemeData(color: darkBlueSeedColor),
      scaffoldBackgroundColor: lightBlueSeedColor,
      textTheme: textTheme,
    );
  }
}
