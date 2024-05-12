import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/features/auth/screens/ressetpassword_screen.dart';
import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:ca_mobile/features/auth/screens/user_information_screen.dart';
import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:ca_mobile/screens/mobile_layout_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
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
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}
