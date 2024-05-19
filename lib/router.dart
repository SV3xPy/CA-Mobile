import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/features/auth/screens/login_screen.dart';
import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/auth/screens/ressetpassword_screen.dart';
import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:ca_mobile/features/auth/screens/user_information_screen.dart';
import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_screen.dart';
import 'package:ca_mobile/screens/settings_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LandingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
    case OptionsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OptionsScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case BottomNavigation.routeName:
      return MaterialPageRoute(
        builder: (context) => const BottomNavigation(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      );
    case ResetPasswordScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      );
    case VerifyingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const VerifyingScreen(),
      );
    case UserInfoScreen.routeName:
      final notEmailLogin = settings.arguments as bool?;
      return MaterialPageRoute(
        builder: (context) =>  UserInfoScreen(notEmailLogin: notEmailLogin?? false),
      );
    case SettingsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}
