import 'dart:io';
import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDayController = TextEditingController();
  final _formUserInfoKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageGallery(context);
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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

  void storeUserData() async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    //String birthDay = birthDayController.text.trim();
    String? birthDate = selectedDate?.toString();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
            lastName,
            birthDate!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Stack(
            children: [
              image == null
                  ? const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                      ),
                      radius: 64,
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 64,
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 15,
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
                  key: _formUserInfoKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Información personal",
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
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Por favor, ingresa tu nombre."),
                          ],
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            "Nombre",
                          ),
                          hintText: "Ingresa tu nombre",
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
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Por favor, ingresa tu apellido."),
                          ],
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            "Apellido",
                          ),
                          hintText: "Ingresa tu apellido",
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
                        controller: birthDayController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Ingresa tu fecha de nacimiento."),
                          ],
                        ),
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Fecha de Nacimiento"),
                          hintText: "Selecciona tu fecha de nacimiento",
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_formUserInfoKey.currentState!.validate()) {
                            storeUserData;
                            print("Info enviada");
                            print("$selectedDate");
                            print("${nameController.text}");
                          }
                        },
                        icon: const Icon(Icons.done),
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
    //   resizeToAvoidBottomInset: false,
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Center(
    //         child: Column(
    //           children: [
    //             Stack(
    //               children: [
    //                 image == null
    //                     ? const CircleAvatar(
    //                         backgroundImage: NetworkImage(
    //                           'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
    //                         ),
    //                         radius: 64,
    //                       )
    //                     : CircleAvatar(
    //                         backgroundImage: FileImage(image!),
    //                         radius: 64,
    //                       ),
    //                 Positioned(
    //                   bottom: -10,
    //                   left: 80,
    //                   child: IconButton(
    //                     onPressed: selectImage,
    //                     icon: const Icon(Icons.add_a_photo),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Container(
    //                   width: size.width * 0.85,
    //                   padding: const EdgeInsets.all(20),
    //                   child: TextField(
    //                     controller: nameController,
    //                     decoration: const InputDecoration(
    //                       hintText: "Ingresa tu nombre",
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Container(
    //                   width: size.width * 0.85,
    //                   padding: const EdgeInsets.all(20),
    //                   child: TextField(
    //                     controller: lastNameController,
    //                     decoration: const InputDecoration(
    //                       hintText: "Ingresa tu apellido",
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.all(20),
    //                   child: const Text(
    //                     "Selecciona tu fecha de nacimiento:",
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //                 IconButton(
    //                   onPressed: () => _selectDate(context),
    //                   icon: const Icon(Icons.calendar_today),
    //                 ),
    //               ],
    //             ),
    //             selectedDate != null
    //                 ? Text(
    //                     "Fecha de nacimiento: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
    //                   )
    //                 : Container(),
    //             IconButton(
    //               onPressed: storeUserData,
    //               icon: const Icon(Icons.done),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
