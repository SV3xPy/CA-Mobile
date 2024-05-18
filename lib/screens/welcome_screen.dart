import 'package:ca_mobile/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF9CAEA9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
            Positioned(
              top: 200.0,
              left: 100.0,
              right: 100.0,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    child: SvgPicture.asset(
                      "assets/grad_cap.png",
                      height: 180.0,
                    ),
                  ),
                  const Text(
                    "EduAgenda",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 29.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 170.0,
              left: 50.0,
              right: 50.0,
              child: Column(
                children: <Widget>[
                  Text(
                    "¡Bienvenido!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 29.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Presiona el botón \"Continuar\" para conocer lo que puedes hacer con EduAgenda",
                    style: TextStyle(
                      color: Color(0xFF38302E),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 130,
              left: 100.0,
              right: 100.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    LandingScreen.routeName,
                  );
                },
                child: Container(
                  width: 150.0,
                  height: 55.0,
                  padding: const EdgeInsets.only(
                    left: 30.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor,
                  ),
                  child: const Row(
                    children: <Widget>[
                      Text(
                        "CONTINUAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 28.0,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
