import 'dart:async';
import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:ca_mobile/features/auth/screens/user_information_screen.dart';

class VerifyingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/verifying-screen';
  const VerifyingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyingScreenState();
}

class _VerifyingScreenState extends ConsumerState<VerifyingScreen>
    with WidgetsBindingObserver {
  int _counter = 0;
  Timer? _resendTimer;
  Timer? _verificationTimer;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startVerificationTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _resendTimer?.cancel();
    _verificationTimer?.cancel();
  }

  void _startVerificationTimer() {
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        bool isVerified =
            await ref.read(authControllerProvider).userVerifiedEmail();
        if (isVerified && mounted) {
          timer.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const UserInfoScreen(notEmailLogin: false,),
            ),
            (route) => false,
          );
        }
      },
    );
  }

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _counter = 60;
    });

    _resendTimer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _isButtonDisabled = false;
          _resendTimer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        try {
          // final success = await ref.read(authControllerProvider).deleteUser();
          // if (success) {
          //   print("Cuenta eliminada con exito.");
          // }
          ref.read(authControllerProvider).deleteUser();
        } catch (e) {
          //print("Error al eliminar la cuenta: $e");
        }
      },
      canPop: true,
      child: CustomScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const Text(
                  'Enlace de verificación enviado.',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Por favor, revisa tu correo y da clic en el enlace para verificar tu cuenta.",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "No salgas de esta pantalla. Al verificar tu correo, espera unos segundos para continuar con tu registro.",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No recibiste ningún correo?",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isButtonDisabled
                              ? null
                              : () async {
                                  await ref
                                      .read(authControllerProvider)
                                      .sendVerificationMail();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Se ha enviado un correo de verificación.'),
                                    ),
                                  );
                                  _startTimer();
                                },
                          child: const Text(
                            " Enviar de nuevo.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _isButtonDisabled
                        ? Text(
                            "Reintentar en $_counter segundos",
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // final size = MediaQuery.of(context).size;
  // Timer.periodic(
  //   const Duration(seconds: 5),
  //   (Timer t) async {
  //     await ref.read(authControllerProvider).userVerifiedEmail().then(
  //       (value) {
  //         if (value) {
  //           t.cancel();
  //           navigateToUserInfoScreen(context);
  //           print('Verificado');
  //         }
  //       },
  //     );
  //   },
  // );

  // return PopScope(
  //   onPopInvoked: (_) async {
  //     try {
  //       final success = await ref.read(authControllerProvider).deleteUser();
  //       if (success) {
  //         print("Cuenta eliminada con exito.");
  //       }
  //     } catch (e) {
  //       print("Error al eliminar la cuenta: $e");
  //     }
  //   },
  //   canPop: true,
  //   child: Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Verificación del correo en proceso"),
  //       elevation: 0,
  //       backgroundColor: backgroundColor,
  //     ),
  //     body: const Center(
  //       child: Padding(
  //         padding: EdgeInsets.all(18.0),
  //         child: Column(
  //           children: [
  //             Text(
  //               'Enlace de verificación enviado.',
  //               style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Text(
  //               "Por favor, revisa tu correo y da clic en el enlace para verificar tu cuenta y continuar con tu registro.",
  //               style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  // );
}
