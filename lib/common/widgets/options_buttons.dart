import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
  });
  final String? buttonText;
  final String? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          onTap!,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(
          30.0,
        ),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}
