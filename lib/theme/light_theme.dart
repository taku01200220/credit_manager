import 'package:flutter/material.dart';

class LightTheme {
  AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: Color(0xFFF5F8FA),
    iconTheme: IconThemeData(
      color: Color(0xFF000000),
    ),
    elevation: 0,
    centerTitle: true,
  );

  // NavigationBarThemeData navigationBarThemeData = const NavigationBarThemeData(
  //   backgroundColor: Color(0xFFFFFFFF),
  //   indicatorColor: Color(0xFFCCCCCC),
  // );

  

  ThemeData themeData(BuildContext context) {
    return ThemeData(
      appBarTheme: appBarTheme,
      // navigationBarTheme: navigationBarThemeData,
      scaffoldBackgroundColor: const Color(0xFFF5F8FA),
    );
  }
}
