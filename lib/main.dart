import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:ca_mobile/features/landing/screens/landing_screen.dart';
import 'package:ca_mobile/router.dart';
import 'package:ca_mobile/screens/mobile_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ca_mobile/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CA_Mobile',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LandingScreen();
                }
                return const MobileLayoutScreen();
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            ));
  }
}
