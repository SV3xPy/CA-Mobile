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
        dividerTheme: const DividerThemeData(
          color: Colors.black,
        ),
        datePickerTheme: const DatePickerThemeData(
          surfaceTintColor: Color(
            0xFFede8e2,
          ),
          shadowColor: Colors.black,
          cancelButtonStyle: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
          dayForegroundColor: MaterialStatePropertyAll(
            Colors.black,
          ),
          todayForegroundColor: MaterialStatePropertyAll(
            Colors.black,
          ),
          weekdayStyle: TextStyle(
            color: Colors.black,
          ),
          dividerColor: Colors.black,
          headerBackgroundColor: Color(
            0xFF9c306c,
          ),
          headerForegroundColor: Colors.black,
          yearForegroundColor: MaterialStatePropertyAll(
            Colors.black,
          ),
        ),
        timePickerTheme: const TimePickerThemeData(
          helpTextStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Color(
            0xFFede8e2,
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
          dialBackgroundColor: Colors.white,
          dialHandColor: Color(
            0xFF9c306c,
          ),
          //dialTextColor: Colors.black,
          hourMinuteColor: Colors.white,
          entryModeIconColor: Colors.black,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          iconColor: Color(
            0xFF9c306c,
          ),
          color: Color(
            0xffd7d4cf,
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
      datePickerTheme: const DatePickerThemeData(
        surfaceTintColor: Color(0xFF12171D),
        shadowColor: Colors.white,
        cancelButtonStyle: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        dayForegroundColor: MaterialStatePropertyAll(
          Colors.white,
        ),
        todayForegroundColor: MaterialStatePropertyAll(
          Colors.white,
        ),
        weekdayStyle: TextStyle(
          color: Colors.white,
        ),
        dividerColor: Colors.white,
        headerBackgroundColor: Color(
          0xFF63CF93,
        ),
        headerForegroundColor: Colors.white,
        yearForegroundColor: MaterialStatePropertyAll(
          Colors.white,
        ),
      ),
      timePickerTheme: const TimePickerThemeData(
        helpTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color(0xFF12171D),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        dialBackgroundColor: Color(
          0xFF282B30,
        ),
        dialHandColor: Color(
          0xFF63CF93,
        ),
        //dialTextColor: Colors.black,
        hourMinuteColor: Color(
          0xFF282B30,
        ),
        hourMinuteTextColor: Colors.white,
        dialTextColor: Colors.white,
        entryModeIconColor: Colors.white,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        iconColor: Color(
          0xFF63CF93,
        ),
        color: Color(
          0xFF282B30,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
