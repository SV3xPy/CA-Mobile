import 'dart:io';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/image_selector.dart';
import 'package:ca_mobile/features/auth/screens/select_photo_options_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ca_mobile/common/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ca_mobile/features/auth/controller/auth_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UserInfoScreen extends ConsumerStatefulWidget {
  final bool notEmailLogin;
  static const String routeName = '/user-information';
  const UserInfoScreen({super.key, required this.notEmailLogin});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  //final nameController = TextEditingController();
  late TextEditingController nameController;
  final lastNameController = TextEditingController();
  final birthDayController = TextEditingController();
  final _formUserInfoKey = GlobalKey<FormState>();
  final ImageService _imageService = ImageService();
  DateTime? selectedDate;
  File? _image;
  String? birthday;
  String? pictureUrl;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    FirebaseAuth.instance.userChanges();
    nameController = TextEditingController();
    if (widget.notEmailLogin) {
      _loadProviderUserData();
    } else if (FirebaseAuth.instance.currentUser != null) {
      nameController.text =
          FirebaseAuth.instance.currentUser!.displayName ?? '';
      _loadUserImage();
    }
    super.initState();
  }

  Future<void> _loadProviderUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var info in user.providerData) {
        if (info.providerId == 'facebook.com') {
          print('FEISSSSSSSSSSSSSSSSSSSS');
          await _loadFacebookUserData();
        } else if (info.providerId == 'google.com') {
          print('GOOOOOOGGGGLLEEEEE');
          await _loadGoogleUserData();
        } else if (info.providerId == 'github.com') {
          print('GIIIIIIHUUUUU');
          await _loadGithubUserData();
        }
      }
    }
  }

  Future<void> _loadFacebookUserData() async {
    final userData = await FacebookAuth.instance
        .getUserData(fields: "name,birthday,last_name,picture");
    setState(() {
      nameController.text = userData['name'] ?? '';
      lastNameController.text = userData['last_name'] ?? '';
      // Parsear la fecha de cumpleaños a un objeto DateTime
      if (userData['birthday'] != null) {
        final birthdayDate =
            DateFormat('MM/dd/yyyy').parse(userData['birthday']);
        selectedDate = birthdayDate;
        birthDayController.text = DateFormat('dd/MM/yyyy').format(birthdayDate);
      }
      pictureUrl = userData['picture']['data']['url'];
      //FirebaseAuth.instance.currentUser!.updatePhotoURL(pictureUrl);
      _loadUserImage();
    });
  }

  Future<void> _loadGithubUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      nameController.text = user?.displayName ?? '';
      //pictureUrl = user?.photoURL;
      print(pictureUrl);
      _loadUserImage();
    });
  }

  Future<void> _loadGoogleUserData() async {
    // Cargar los datos de Google si es necesario
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      nameController.text = user?.displayName ?? '';
      //pictureUrl = user?.photoURL;
      print(pictureUrl);
      _loadUserImage();
    });
  }

  Future<File> _downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath = path.join(documentDirectory.path, 'user_image.jpg');
    final file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<void> _loadUserImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL != null) {
      final File file = await _downloadFile(user!.photoURL!);
      setState(() {
        _image = file;
      });
    }
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
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
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
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    return CustomScaffold(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _image == null ? print("Imagen null") : print('Algo aqui');

                  _imageService.showSelectPhotoOptions(context, (source) async {
                    File? selectedImage =
                        await _imageService.selectImage(context, source, (img) {
                      setState(() {
                        _image = img;
                        Navigator.of(context).pop();
                      });
                      _image == null
                          ? print("Imagen null")
                          : print('Algo aqui');
                    });
                  });
                },
                child: _image == null
                    ? CircleAvatar(
                        backgroundImage:
                            widget.notEmailLogin && photoUrl != null
                                ? NetworkImage(photoUrl)
                                : const NetworkImage(
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
                        icon: Icon(
                          Icons.done,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black // Color para el modo claro
                                  : Colors.white, // Color para el modo oscuro
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
  }
}
