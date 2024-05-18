import 'dart:async';

import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static const String routeName = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formResetKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isButtonDisabled = false;
  int _counter = 0;
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    emailController.dispose();
  }

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _counter = 10;
    });

    _timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _isButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
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
                  key: _formResetKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Restablecer contraseña",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const Text(
                        "Ingresa tu correo electrónico para recibir un correo con un enlace para realizar el cambio de tu contraseña.",
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          label: const Text(
                            "Correo electrónico",
                          ),
                          hintText: "Ingrese su correo electrónico",
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
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
                          onPressed: _isButtonDisabled
                              ? null
                              : () {
                                  ref
                                      .read(
                                        authControllerProvider,
                                      )
                                      .resetPassword(
                                        emailController.text,
                                      )
                                      .then(
                                    (value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Se ha enviado un correo.',
                                            ),
                                          ),
                                        );
                                        _startTimer();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'El usuario no existe.',
                                            ),
                                          ),
                                        );
                                      }
                                      //_startTimer();
                                    },
                                  );
                                },
                          child: _isButtonDisabled
                              ? Text(
                                  "Reintentar en $_counter segundos",
                                )
                              : const Text(
                                  "Enviar",
                                ),
                        ),
                      ),
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
    //     title: const Text("Reestablecer contraseña"),
    //     elevation: 0,
    //     backgroundColor: backgroundColor,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(18.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           const Center(
    //             child: Text("Recupere su contraseña."),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           TextFormField(
    //             controller: emailController,
    //             keyboardType: TextInputType.emailAddress,
    //             decoration: const InputDecoration(
    //               hintText: 'Correo Electronico',
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 30,
    //           ),
    //           CustomButton(
    //             text: 'Enviar correo de recuperación',
    //             onPressed: () {
    //               ref
    //                   .read(6
    //                     authControllerProvider,
    //                   )
    //                   .resetPassword(
    //                     emailController.text,
    //                   )
    //                   .then(
    //                 (value) {
    //                   if (value) {
    //                     ScaffoldMessenger.of(context).showSnackBar(
    //                       const SnackBar(
    //                         content: Text(
    //                           'Se ha enviado un correo.',
    //                         ),
    //                       ),
    //                     );
    //                     Navigator.pop(context);
    //                   } else {
    //                     ScaffoldMessenger.of(context).showSnackBar(
    //                       const SnackBar(
    //                         content: Text(
    //                           'El usuario no existe.',
    //                         ),
    //                       ),
    //                     );
    //                   }
    //                 },
    //               );
    //             },
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
