import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:ca_mobile/features/auth/screens/login_screen.dart';
import 'package:ca_mobile/features/auth/screens/verifying_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  // final confirmPasswordController = TextEditingController();
  final _formSignUpKey = GlobalKey<FormState>();

  void navigateToVerifyingScreen(BuildContext context) {
    Navigator.pushNamed(context, VerifyingScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                25.0,
                50.0,
                25.0,
                20.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    40.0,
                  ),
                  topRight: Radius.circular(
                    40.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Registrarse",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Por favor, ingresa un correo."),
                            FormBuilderValidators.email(
                                errorText: "Ingresa un correo valido."),
                          ],
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            "Correo electrónico",
                          ),
                          hintText: "Ingrese un correo electrónico",
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        obscuringCharacter: "*",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText:
                                    "Por favor, ingresa una contraseña."),
                            (val) {
                              if (val!.length < 6) {
                                return "La contraseña debe de tener al menos 6 caracteres.";
                              }
                              return null;
                            }
                          ],
                        ),
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignUpKey.currentState!.validate()) {
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
                                        content: Text(
                                            'Ocurrió un error con el registro.'),
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                          child: const Text(
                            "Registrarse",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿Ya tienes una cuenta?",
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                LoginScreen.routeName,
                              );
                            },
                            child: const Text(
                              " ¡Inicia sesión!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // final size = MediaQuery.of(context).size;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Crear una cuenta"),
    //     elevation: 0,
    //     backgroundColor: backgroundColor,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(15.0),
    //       child: Form(
    //         key: formKey,
    //         child: Column(
    //           children: [
    //             TextFormField(
    //               controller: emailController,
    //               keyboardType: TextInputType.emailAddress,
    //               decoration: const InputDecoration(
    //                 hintText: 'Correo Electronico',
    //               ),
    //               autovalidateMode: AutovalidateMode.onUserInteraction,
    //               validator: FormBuilderValidators.compose(
    //                 [
    //                   FormBuilderValidators.required(
    //                       errorText: "Por favor, ingresa un correo."),
    //                   FormBuilderValidators.email(
    //                       errorText: "Ingresa un correo valido."),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             TextFormField(
    //               controller: passwordController,
    //               keyboardType: TextInputType.text,
    //               obscureText: true,
    //               decoration: const InputDecoration(
    //                 hintText: 'Contraseña',
    //               ),
    //               autovalidateMode: AutovalidateMode.onUserInteraction,
    //               validator: FormBuilderValidators.compose(
    //                 [
    //                   FormBuilderValidators.required(
    //                       errorText: "Por favor, ingresa una contraseña."),
    //                   (val) {
    //                     if (val!.length < 6) {
    //                       return "La contraseña debe de tener al menos 6 caracteres.";
    //                     }
    //                     return null;
    //                   }
    //                 ],
    //               ),
    //             ),
    //             SizedBox(
    //               height: size.height * 0.5,
    //             ),
    //             CustomButton(
    //               text: 'REGISTRARSE',
    //               onPressed: () {
    //                 if (formKey.currentState!.validate()) {
    //                   ref
    //                       .read(authControllerProvider)
    //                       .signUpWithEmail(
    //                         context,
    //                         emailController.text,
    //                         passwordController.text,
    //                       )
    //                       .then(
    //                     (value) {
    //                       if (value) {
    //                         ScaffoldMessenger.of(context).showSnackBar(
    //                           const SnackBar(
    //                             content: Text(
    //                                 'Se ha enviado un correo de verificación.'),
    //                           ),
    //                         );
    //                         navigateToVerifyingScreen(context);
    //                       } else {
    //                         ScaffoldMessenger.of(context).showSnackBar(
    //                           const SnackBar(
    //                             content:
    //                                 Text('Ocurrió un error con el registro.'),
    //                           ),
    //                         );
    //                       }
    //                     },
    //                   );
    //                 }
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
