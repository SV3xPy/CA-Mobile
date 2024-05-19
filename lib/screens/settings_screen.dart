import 'dart:io';

import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';

import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDayController = TextEditingController();
  final _formUserInfoKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  File? _image;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _dialogBuilder(
      BuildContext context, Color? bg, Color txt, Color? logo) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: bg,
            title: Text(
              'Actualizar Datos',
              style: TextStyle(
                color: txt,
              ),
            ),
            content: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //_showSelectPhotoOptions(context);
                      },
                      child: _image == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                              ),
                              radius: 64,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(_image!),
                              radius: 64,
                            ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          //_showSelectPhotoOptions(context);
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    10.0,
                    30.0,
                    10.0,
                    0,
                  ),
                  child: Form(
                    key: _formUserInfoKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Información personal",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: txt,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(color: txt),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: "Por favor, ingresa tu nombre."),
                            ],
                          ),
                          decoration: const InputDecoration(
                            label: Text(
                              "Nombre",
                              style: TextStyle(
                                color: txtColor,
                              ),
                            ),
                            hintText: "Ingresa tu nombre",
                            hintStyle: TextStyle(
                              color: txtColor,
                            ),
                            // border: OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //     color: Colors.black12, // Default border color
                            //   ),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //     color: Colors.black12, // Default border color
                            //   ),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(color: txt),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: "Por favor, ingresa tu apellido."),
                            ],
                          ),
                          decoration: const InputDecoration(
                            label: Text(
                              "Apellido",
                              style: TextStyle(
                                color: txtColor,
                              ),
                            ),
                            hintText: "Ingresa tu apellido",
                            hintStyle: TextStyle(
                              color: txtColor,
                            ),
                            // border: OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //     color: Colors.black12, // Default border color
                            //   ),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //     color: Colors.black12, // Default border color
                            //   ),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: birthDayController,
                          readOnly: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(color: txt),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: "Ingresa tu fecha de nacimiento."),
                            ],
                          ),
                          onTap: () {}, //_selectDate(context),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.calendar_today,
                              color: logo,
                            ),
                            label: const Text(
                              "Fecha de Nacimiento",
                              style: TextStyle(
                                color: txtColor,
                              ),
                            ),
                            hintText: "Selecciona tu fecha de nacimiento",
                            hintStyle: const TextStyle(
                              color: txtColor,
                            ),
                            // border: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.black12),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.black12),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Actualizar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Salir'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ajustes",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.transparent,
                onTap: () {
                  Color txtColor =
                      tSwitchProvider ? Colors.white : Colors.black;
                  Color? bgColor = tSwitchProvider
                      ? const Color(0xFF12171D)
                      : const Color(0xffede8e2);
                  Color? iconColor = tSwitchProvider
                      ? const Color(0xFF63CF93)
                      : const Color(0xFF9c306c);
                  _dialogBuilder(context, bgColor, txtColor, iconColor);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          "assets/bg.png",
                          height: 65,
                          width: 65,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "data",
                              style: TextStyle(
                                color: tSwitchProvider
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFF000000),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Cambia tu información personal.",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: txtColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  child: Icon(
                    tSwitchProvider ? Icons.nightlight : Icons.sunny,
                    color: tSwitchProvider
                        ? const Color(0xFF63CF93)
                        : const Color(0xFF9c306c),
                  ),
                ),
                title: Text(
                  "Cambiar tema",
                  style: TextStyle(
                    color: tSwitchProvider
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF000000),
                    fontSize: 17,
                  ),
                ),
                subtitle: const Text(
                  "Tema claro u oscuro",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 15,
                  ),
                ),
                trailing: Switch(
                  value: tSwitchProvider,
                  onChanged: (value) {
                    ref.read(themeSwitchProvider.notifier).state = value;
                  },
                  activeColor: Colors.orangeAccent,
                ),
              ),
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.transparent,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: tSwitchProvider
                          ? const Color(0xFF63CF93)
                          : const Color(0xFF9c306c),
                    ),
                  ),
                  title: Text(
                    "Acerca De",
                    style: TextStyle(
                      color: tSwitchProvider
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                      fontSize: 17,
                    ),
                  ),
                  subtitle: const Text(
                    "Información de la aplicación",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.transparent,
                onTap: () {
                  ref.read(authControllerProvider).signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OptionsScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                    ),
                    child: Icon(
                      Icons.logout,
                      color: tSwitchProvider
                          ? const Color(0xFF63CF93)
                          : const Color(0xFF9c306c),
                    ),
                  ),
                  title: Text(
                    "Salir",
                    style: TextStyle(
                      color: tSwitchProvider
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                      fontSize: 17,
                    ),
                  ),
                  subtitle: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/grad_cap.png",
                      height: 38.8,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "EduAgenda",
                      style: TextStyle(
                        color: tSwitchProvider
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF000000),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
