import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/features/auth/screens/login_screen.dart';
import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/auth/screens/ressetpassword_screen.dart';
import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:ca_mobile/features/auth/screens/user_information_screen.dart';
import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
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
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case SettingsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );
    case AddEventScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}
