import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:ca_mobile/common/widgets/image_selector.dart';
import 'package:ca_mobile/features/auth/screens/options_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/firebase_messaging.dart';
import 'package:ca_mobile/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String loginType = "";
  bool isPremium = false;
  final FirebaseCM _firebaseCM = FirebaseCM();

  bool inscSusc = false;
  bool inscPrem = false;
  bool inscNov = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    lastNameController.dispose();
    birthDayController.dispose();
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
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthDayController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  void loginTypee() async {
    final prefs = await SharedPreferences.getInstance();
    loginType = prefs.getString('loginType') ?? 'default';
  }

  void isPremiumm() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    isPremium = await ref.read(authControllerProvider).checkIsPremium(id);
  }

  void handleSwitchChange(bool value) async {
    isPremiumm(); // Espera a que isPremiumm() complete
    if (isPremium) {
      ref.read(themeSwitchProvider.notifier).state = value;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Funcionalidad Premium"),
              content: const Text(
                  "Esta es una función premium. ¿Quieres pagar con PayPal para habilitarla?"),
              actions: <Widget>[
                TextButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(tabColor),
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(tabColor),
                  ),
                  child: const Text('Pagar con Paypal'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalCheckoutView(
                          sandboxMode: true,
                          clientId:
                              "AYbw1mHYmniyio7oPTS_P1WOsusg63GFgciYkTb7a0_YJt-mUu-ZXOxZ-pH5cNIPx1MIqaO3dqHQeE0T",
                          secretKey:
                              "EDsCfII1HJpYs6H7by1XCL7cmyIswEMw8DmtVFg5LtviLUwteKqFBubHS8q-D2-TP6987ly0qBwMcxx0",
                          transactions: const [
                            {
                              "amount": {
                                "total": '25',
                                "currency": "MXN",
                                "details": {
                                  "subtotal": '25',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                                  "The payment transaction description.",
                              "payment_options": {
                                "allowed_payment_method":
                                    "INSTANT_FUNDING_SOURCE"
                              },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "Suscripción Premium",
                                    "quantity": 1,
                                    "price": '25',
                                    "currency": "MXN"
                                  },
                                ],
                              }
                            }
                          ],
                          note: "Derechos reservados S.A de C.V",
                          onSuccess: (Map params) async {
                            log("onSuccess: $params");
                            ref.read(authControllerProvider).setPremium();
                            Navigator.pop(context);
                          },
                          onError: (error) {
                            log("onError: $error");
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            log('cancelled:');
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          });
      // Opcionalmente, puedes revertir el cambio del switch
      // ref.read(tSwitchProvider.notifier).state =!value;
    }
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    String lastName = lastNameController.text.trim();
    String? birthDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : birthDayController.text;
    if (name.isNotEmpty) {
      if (_image == null) {
        ref
            .read(authControllerProvider)
            .updateUserDataNOIMGToFirebase(context, name, lastName, birthDate);
      } else {
        ref.read(authControllerProvider).updateUserDataToFirebase(
              context,
              name,
              _image!,
              lastName,
              birthDate,
            );
      }
    }
  }

  Future<void> _dialogBuilder(
      BuildContext context, Color? bg, Color txt, Color? logo) {
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    loginTypee();
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
              return Text('Error: ${snapshot.error}');
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
                              if (loginType == 'email') {
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
                              } else {
                                showSnackBar(
                                    context: context,
                                    content:
                                        "Opción solo disponible con email");
                              }
                            },
                            child: CircleAvatar(
                              radius: 64.0,
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
                          ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () {
                                if (loginType == 'email') {
                                  _imageService.showSelectPhotoOptions(context,
                                      (source) async {
                                    File? selectedImage = await _imageService
                                        .selectImage(context, source, (img) {
                                      setState(() {
                                        _image = img;
                                        //print(_image);
                                        Navigator.of(context).pop();
                                      });
                                    });
                                  });
                                } else {
                                  showSnackBar(
                                      context: context,
                                      content:
                                          "Opción solo disponible con email");
                                }
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
                                decoration: InputDecoration(
                                  label: Text(
                                    "Nombre",
                                    style: TextStyle(
                                      color: txt,
                                    ),
                                  ),
                                  hintText: "Ingresa tu nombre",
                                  hintStyle: TextStyle(
                                    color: txt,
                                  ),
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
                                decoration: InputDecoration(
                                  label: Text(
                                    "Apellido",
                                    style: TextStyle(
                                      color: txt,
                                    ),
                                  ),
                                  hintText: "Ingresa tu apellido",
                                  hintStyle: TextStyle(
                                    color: txt,
                                  ),
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
                                },
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: logo,
                                  ),
                                  label: Text(
                                    "Fecha de Nacimiento",
                                    style: TextStyle(
                                      color: txt,
                                    ),
                                  ),
                                  hintText: "Selecciona tu fecha de nacimiento",
                                  hintStyle: TextStyle(
                                    color: txt,
                                  ),
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
                      style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(txt),
                      ),
                      child: const Text('Actualizar'),
                      onPressed: () {
                        storeUserData();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(txt),
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

  void handleSubscription(String topic, bool subscribe) async {
    if (subscribe) {
      await _firebaseCM.subscribeToTopic(topic);
      print("Te has suscrito a: $topic");
    } else {
      await _firebaseCM.unsubscribeFromTopic(topic);
      print("Te has desuscrito de: $topic");
    }

    // setState(() {
    //   if (topic == 'inscripcion') {
    //     inscSusc = subscribe;
    //   } else if (topic == 'promos') {
    //     inscPrem = subscribe;
    //   } else if (topic == 'novedades') {
    //     inscNov = subscribe;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? userName = user?.displayName;
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgContainer =
        tSwitchProvider ? const Color(0xFF282B30) : const Color(0xffd7d4cf);
    final bgDialog =
        tSwitchProvider ? const Color(0xFF12171D) : const Color(0xffede8e2);

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
                  _dialogBuilder(context, bgDialog, txtColor, iconColor);
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
                                  color: txtColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                minFontSize:
                                    12, // Establece el tamaño mínimo del texto
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
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
                    color: iconColor,
                  ),
                ),
                title: Text(
                  "Cambiar tema",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 17,
                  ),
                ),
                subtitle: Text(
                  "Tema claro u oscuro",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 15,
                  ),
                ),
                trailing: Switch(
                  value: tSwitchProvider,
                  onChanged: (value) {
                    handleSwitchChange(value);
                  },
                  activeColor: Colors.orangeAccent,
                ),
              ),
              InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.transparent,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: bgDialog,
                              title: Text("Preferencias Notificaciones",
                                  style: TextStyle(color: txtColor)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Inscripciones',
                                      style: TextStyle(color: txtColor),
                                    ),
                                    onTap: () {
                                      //Navigator.of(context).pop();
                                    },
                                    trailing: Switch(
                                      value: inscSusc,
                                      onChanged: (value) {
                                        handleSubscription(
                                          "inscripcion",
                                          value,
                                        );
                                        setState(() {
                                          inscSusc = value;
                                        });
                                      },
                                      activeColor: Colors.orangeAccent,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Premium',
                                        style: TextStyle(color: txtColor)),
                                    onTap: () {
                                      //Navigator.of(context).pop();
                                    },
                                    trailing: Switch(
                                      value: inscPrem,
                                      onChanged: (value) {
                                        handleSubscription(
                                          "promo",
                                          value,
                                        );
                                        setState(() {
                                          inscPrem = value;
                                        });
                                      },
                                      activeColor: Colors.orangeAccent,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Novedades',
                                        style: TextStyle(color: txtColor)),
                                    onTap: () {
                                      //Navigator.of(context).pop();
                                    },
                                    trailing: Switch(
                                      value: inscNov,
                                      onChanged: (value) {
                                        handleSubscription(
                                          "novedades",
                                          value,
                                        );
                                        setState(() {
                                          inscNov = value;
                                        });
                                      },
                                      activeColor: Colors.orangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                    "Notificaciones",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    "Administra tus notifiaciones",
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
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                    "Acerca De",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
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
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                    "Salir",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
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
                        color: txtColor,
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
