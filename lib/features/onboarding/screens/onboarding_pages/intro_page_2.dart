import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          const Text(
            "¿Terminaste tus tareas?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          Transform.scale(
            scale: 1.2,
            child: LottieBuilder.network(
                'https://lottie.host/7898d740-a5cb-435e-b708-980ac6cd6881/P7WTCd23By.json'),
          ),
          const SizedBox(
            height: 130,
          ),
          const Text(
            "Crea una lista con todas tus tareas, así sabrás cuales te faltan por completar.",
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
