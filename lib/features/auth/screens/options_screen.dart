import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:ca_mobile/common/widgets/options_buttons.dart';
import 'package:ca_mobile/features/auth/screens/login_screen.dart';
import 'package:ca_mobile/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  static const routeName = '/options';
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Bienvenido\n",
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "\nInicie sesión con su cuenta o cree una nueva.",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: OptionsButton(
                      buttonText: "Entrar",
                      onTap: LoginScreen.routeName,
                      color: Colors.transparent,
                      textColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: OptionsButton(
                      buttonText: "Registrarse",
                      onTap: SignupScreen.routeName,
                      color: Colors.white,
                      textColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
