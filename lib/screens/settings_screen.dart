import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:ca_mobile/common/widgets/image_selector.dart';
import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final ImageService _imageService = ImageService();
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

  Future<void> _selectDate(BuildContext context) async {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final DateTime? picked = await showDatePicker(
      helpText: "Seleccióna la fecha",
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: tSwitchProvider
              ? ThemeData.dark().copyWith(
                  colorScheme: darkColorScheme,
                  dialogBackgroundColor: darkColorScheme.background,
                )
              : ThemeData.light().copyWith(
                  colorScheme: lightColorScheme,
                  dialogBackgroundColor: lightColorScheme.background,
                ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthDayController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  Future<void> _dialogBuilder(
      BuildContext context, Color? bg, Color txt, Color? logo) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<UserModel?>(
          future: ref.read(authControllerProvider).getUserData(), // Tu Future
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            // Comienza el builder interno de FutureBuilder
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Comprueba si el Future aún se está cargando
              return const CircularProgressIndicator(); 
            } else if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); 
            } else {
              final userData = snapshot.data; // Accede a los datos del Future
              nameController.text = userData!.name;
              lastNameController.text = userData.lastName;
              birthDayController.text = userData.birthDay;
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
                              _imageService.showSelectPhotoOptions(context,
                                  (source) async {
                                File? selectedImage = await _imageService
                                    .selectImage(context, source, (img) {
                                  setState(() {
                                    _image = img;
                                    Navigator.of(context).pop();
                                  });
                                });
                              });
                            },
                            child: _image == null
                                ?  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      userData.profilePic,
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
                                _imageService.showSelectPhotoOptions(context,
                                    (source) async {
                                  File? selectedImage = await _imageService
                                      .selectImage(context, source, (img) {
                                    setState(() {
                                      _image = img;
                                      Navigator.of(context).pop();
                                    });
                                  });
                                });
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: txt),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Por favor, ingresa tu nombre."),
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: txt),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Por favor, ingresa tu apellido."),
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: txt),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Ingresa tu fecha de nacimiento."),
                                  ],
                                ),
                                onTap: () {
                                  _selectDate(context);
                                }, //_selectDate(context),
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
            }
          }, // Cierra el builder interno de FutureBuilder
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? userName = user?.displayName;
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
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: photoUrl != null
                            ? CachedNetworkImageProvider(photoUrl)
                            : null,
                        child: photoUrl == null
                            ? CachedNetworkImage(
                                imageUrl:
                                    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : null,
                      ),
                      const SizedBox(
                          width:
                              20.0), // Agrega un espacio entre el avatar y el texto
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                userName ?? "Nombre usuario",
                                style: TextStyle(
                                  color: tSwitchProvider
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                minFontSize:
                                    12, // Establece el tamaño mínimo del texto
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
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
