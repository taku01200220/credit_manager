import 'package:flutter/material.dart';

class DarkTheme {
  // // primarySwatch
  // static const int _customPrimarySwatch = 0xFF333333;
  // static const MaterialColor customPrimarySwatch = MaterialColor(
  //   _customPrimarySwatch,
  //   <int, Color>{
  //     50: Color(0xFFE7E7E7),
  //     100: Color(0xFFC2C2C2),
  //     200: Color(0xFF999999),
  //     300: Color(0xFF707070),
  //     400: Color(0xFF525252),
  //     500: Color(_customPrimarySwatch),
  //     600: Color(0xFF2E2E2E),
  //     700: Color(0xFF272727),
  //     800: Color(0xFF202020),
  //     900: Color(0xFF141414),
  //   },
  // );

  AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: Color(0xFF333333),
    iconTheme: IconThemeData(
      color: Color(0xFFFFFFFF),
    ),
    elevation: 0,
    centerTitle: true,
  );

  DrawerThemeData drawerTheme = const DrawerThemeData(
    backgroundColor: Color(0xFF333333),
  );

  // NavigationBarThemeData navigationBarThemeData = NavigationBarThemeData(
  //   backgroundColor: const Color(0xFF333333),
  //   indicatorColor: const Color(0xFF666666),
  //   labelTextStyle: MaterialStateProperty.all(
  //     const TextStyle(
  //       color: Color(0xFFFFFFFF),
  //     ),
  //   ),
  //   iconTheme: MaterialStateProperty.all(
  //     const IconThemeData(
  //       color: Color(0xFFFFFFFF),
  //     ),
  //   ),
  // );

  TextTheme textTheme = const TextTheme(
    bodyText2: TextStyle(color: Color(0xFFFFFFFF),),
  );

  ListTileThemeData listTileTheme = const ListTileThemeData(
    iconColor: Color(0xFFFFFFFF),
    textColor: Color(0xFFFFFFFF),
  );

  ThemeData themeData(BuildContext context) {
    return ThemeData(
      // primarySwatch: customPrimarySwatch,
      appBarTheme: appBarTheme,
      drawerTheme: drawerTheme,
      // navigationBarTheme: navigationBarThemeData,
      scaffoldBackgroundColor: const Color(0xFF000000),
      textTheme: textTheme,
      listTileTheme: listTileTheme,
    );
  }
}
