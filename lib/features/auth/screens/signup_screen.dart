import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/custom_button.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
//import 'package:ca_mobile/features/landing/screens/verifying_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void navigateToVerifyingScreen(BuildContext context) {
    Navigator.pushNamed(context, VerifyingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear una cuenta"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Correo Electronico',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Por favor, ingresa un correo."),
                      FormBuilderValidators.email(
                          errorText: "Ingresa un correo valido."),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Contraseña',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Por favor, ingresa una contraseña."),
                      (val) {
                        if (val!.length < 6) {
                          return "La contraseña debe de tener al menos 6 caracteres.";
                        }
                        return null;
                      }
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.5,
                ),
                CustomButton(
                  text: 'REGISTRARSE',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ref
                          .read(authControllerProvider)
                          .signUpWithEmail(
                            context,
                            emailController.text,
                            passwordController.text,
                          )
                          .then(
                        (value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se ha enviado un correo de verificación.'),
                              ),
                            );
                            navigateToVerifyingScreen(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Ocurrió un error con el registro.'),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
