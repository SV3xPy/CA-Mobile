import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = FutureProvider<SharedPreferences>(
  (ref) {
    return SharedPreferences.getInstance();
  },
);

final themeSwitchProvider = StateProvider<bool>(
  (ref) {
    final sharedPreferences = ref.watch(sharedPrefProvider);
    final theme = sharedPreferences.value?.getString("themeMode");
    return theme == "dark" ? true : false;
  },
);

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) {
    final sharedPreferences = ref.watch(sharedPrefProvider);
    final themeSwitch = ref.watch(themeSwitchProvider);
    if (themeSwitch) {
      sharedPreferences.value?.setString("themeMode", "dark");
    } else {
      sharedPreferences.value?.setString("themeMode", "light");
    }

    final theme = sharedPreferences.value?.getString("themeMode");
    return theme == "dark" ? ThemeMode.dark : ThemeMode.light;
  },
);
