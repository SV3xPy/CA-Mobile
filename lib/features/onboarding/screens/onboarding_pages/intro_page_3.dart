import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Conoce tus calificaciones.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Transform.scale(
            scale: 1.0,
            child: LottieBuilder.network(
                'https://lottie.host/0862e555-006d-4c1b-a491-3770c99229ff/cUNhR3PZOB.json'),
          ),
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Añade tus calificaciones en cada materia para conocer tu rendimiento académico.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
