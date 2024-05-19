import 'dart:io';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/features/auth/screens/select_photo_options_screen.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  File? _image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future selectImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Editar Foto',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: backgroundColor,
              activeControlsWidgetColor: Colors.blue,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.22,
          maxChildSize: 0.3,
          minChildSize: 0.22,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: selectImage,
              ),
            );
          }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
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

  void storeUserData() async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String? birthDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : null;

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            _image,
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
              GestureDetector(
                onTap: () {
                  _showSelectPhotoOptions(context);
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
                    _showSelectPhotoOptions(context);
                  },
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
                        decoration: const InputDecoration(
                          label: Text(
                            "Nombre",
                          ),
                          hintText: "Ingresa tu nombre",
                          hintStyle: TextStyle(
                            color: Colors.black26,
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
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Por favor, ingresa tu apellido."),
                          ],
                        ),
                        decoration: const InputDecoration(
                          label: Text(
                            "Apellido",
                          ),
                          hintText: "Ingresa tu apellido",
                          hintStyle: TextStyle(
                            color: Colors.black26,
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
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Ingresa tu fecha de nacimiento."),
                          ],
                        ),
                        onTap: () => _selectDate(context),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          label: Text("Fecha de Nacimiento"),
                          hintText: "Selecciona tu fecha de nacimiento",
                          hintStyle: TextStyle(color: Colors.black26),
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
                      const SizedBox(
                        height: 25.0,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_formUserInfoKey.currentState!.validate()) {
                            storeUserData();
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
  }
}
