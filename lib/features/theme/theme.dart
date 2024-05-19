import 'package:flutter/material.dart';

class AppTheme {
  // static const lightColorScheme = ColorScheme(
  //   brightness: Brightness.light,
  //   primary: Color(0xFF416FDF),
  //   onPrimary: Color(0xFFFFFFFF),
  //   secondary: Color(0xFF6EAEE7),
  //   onSecondary: Color(0xFFFFFFFF),
  //   error: Color(0xFFBA1A1A),
  //   onError: Color(0xFFFFFFFF),
  //   background: Color(0xFFFCFDF6),
  //   onBackground: Color(0xFF1A1C18),
  //   shadow: Color(0xFF000000),
  //   outlineVariant: Color(0xFFC2C8BC),
  //   surface: Color(0xFFF9FAF3),
  //   onSurface: Color(0xFF1A1C18),
  // );

  // static const darkColorScheme = ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: Color(0xFFBE9020),
  //   onPrimary: Color(0xFF000000),
  //   secondary: Color(0xFF915118),
  //   onSecondary: Color(0xFF000000),
  //   error: Color(0xFFBA1A1A),
  //   onError: Color(0xFF000000),
  //   background: Color(0xFF030209),
  //   onBackground: Color(0xFFe5e3e7),
  //   shadow: Color(0xFF000000),
  //   outlineVariant: Color(0xFF3d3743),
  //   surface: Color(0xFF06050c),
  //   onSurface: Color(0xFFe5e3e7),
  // );

  static ThemeData lightTheme() {
    return ThemeData(
        //colorScheme: lightColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF416FDF), // Slightly darker shade for the button
            ),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.white), // text color
            elevation: MaterialStateProperty.all<double>(5.0), // shadow
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Adjust as needed
              ),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFede8e2),
          selectedIconTheme: IconThemeData(
            color: Color(0xFF9c306c),
          ),
          unselectedIconTheme: IconThemeData(
            color: Color(0xFF938e8b),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFede8e2),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: const TextStyle(
            color: Colors.black26,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity);
  }

  static ThemeData darkTheme() {
    return ThemeData(
        //colorScheme: darkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFFBE9020), // Slightly darker shade for the button
            ),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.white), // text color
            elevation: MaterialStateProperty.all<double>(5.0), // shadow
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Adjust as needed
              ),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF12171D),
          selectedIconTheme: IconThemeData(
            color: Color(0xFF63CF93),
          ),
          unselectedIconTheme: IconThemeData(
            color: Color(0xFF6C7174),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF12171D),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFBE9020),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFBE9020),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFBE9020),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: const TextStyle(
            color: Color(0xFFBE9020),
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFBE9020),
          ),
        ),
        dividerColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity);
  }
}
