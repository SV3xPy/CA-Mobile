import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/features/auth/screens/login_screen.dart';
import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/auth/screens/ressetpassword_screen.dart';
import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:ca_mobile/features/auth/screens/user_information_screen.dart';
import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
import 'package:ca_mobile/features/events/screen/event_details.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_screen.dart';
import 'package:ca_mobile/features/schedule/screen/add_schedule_screen.dart';
import 'package:ca_mobile/features/schedule/screen/schedule_details.dart';
import 'package:ca_mobile/features/subjects/screen/add_subject_screen.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:ca_mobile/models/schedule_model.dart';
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
        builder: (context) =>
            UserInfoScreen(notEmailLogin: notEmailLogin ?? false),
      );
    case SettingsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );
    case AddEventScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      );
    case AddEventScreen.routeNameUpdate:
      final event = settings.arguments as EventModel;
      return MaterialPageRoute(
        builder: (context) => AddEventScreen(event: event),
      );
    case AddSubjectScreen.routeName:
      final subjectId = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => AddSubjectScreen(
          subjectId: subjectId,
        ),
      );
    case AddScheduleScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddScheduleScreen(),
      );
    case AddScheduleScreen.routeNameUpdate:
      final schedule = settings.arguments as ScheduleModel;
      return MaterialPageRoute(
        builder: (context) => AddScheduleScreen(
          schedule: schedule,
        ),
      );
    case EventDetailsScreen.routeName:
      final event = settings.arguments as EventModel;
      return MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: event,
        ),
      );
    case ScheduleDetailsScreen.routeName:
      final event = settings.arguments as ScheduleModel;
      return MaterialPageRoute(
        builder: (context) => ScheduleDetailsScreen(
          schedule: event,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}
