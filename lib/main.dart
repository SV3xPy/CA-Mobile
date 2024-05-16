import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:ca_mobile/features/onboarding/screens/onboarding_screen.dart';
import 'package:ca_mobile/router.dart';
import 'package:ca_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ca_mobile/firebase_options.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CA_Mobile',
        theme: ThemeData(
          primaryColor: const Color(
            0xFF202328,
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(
              0xFF202328,
            ),
            onPrimary: Colors.black,
            secondary: Colors.transparent,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            background: Color(
              0xFF12171D,
            ),
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          hintColor: const Color(0xFF63CF93),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LandingScreen();
                }
                return const HomeScreen();
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
