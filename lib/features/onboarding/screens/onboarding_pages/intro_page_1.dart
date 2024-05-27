import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

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
            "Revisa tus horarios de clase.",
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
            scale: 1.2,
            child: LottieBuilder.asset("assets/clock_alarm.json"),
          ),
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Añade los horarios de todas tus materias para poder consultarlos en cualquier momento.",
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
