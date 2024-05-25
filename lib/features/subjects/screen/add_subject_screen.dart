import 'package:ca_mobile/features/subjects/controller/subject_controller.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddSubjectScreen extends ConsumerStatefulWidget {
  static const routeName = '/add_subject';
  const AddSubjectScreen({super.key});

  @override
  ConsumerState<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends ConsumerState<AddSubjectScreen>
    with WidgetsBindingObserver {
  final subjectNameController = TextEditingController();
  final profNameController = TextEditingController();
  final colorController = TextEditingController();
  final _formSubjectKey = GlobalKey<FormState>();
  Color color = Colors.red;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    subjectNameController.dispose();
    profNameController.dispose();
    colorController.dispose();
  }

  Widget buildColorPicker() {
    return ColorPicker(
      pickerColor: color,
      onColorChanged: (color) {
        setState(() {
          this.color = color;
        });
      },
    );
  }

  void pickColors(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Selecciona un color",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorPicker(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Seleccionar",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void storeSubjectData() async{
    String subject = subjectNameController.text.trim();
    String teacherName = profNameController.text.trim();
    if(subject.isNotEmpty){
      ref.read(subjectControllerProvider).saveSubjectDataToFirebase(context,subject,teacherName,color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final datetimeBorder =
        tSwitchProvider ? const Color(0xFFBE9020) : Colors.black12;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nueva materia",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                3.0,
                10.0,
                3.0,
                0,
              ),
              child: Form(
                key: _formSubjectKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: subjectNameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        color: txtColor,
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: "Por favor, ingresa un nombre.",
                          ),
                        ],
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          "Nombre materia",
                          style: TextStyle(
                            color: txtColor,
                          ),
                        ),
                        hintText: "Nombre de la materia",
                        hintStyle: TextStyle(
                          color: txtColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: profNameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        color: txtColor,
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: "Por favor, ingresa un nombre.",
                          ),
                        ],
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          "Nombre profesor",
                          style: TextStyle(
                            color: txtColor,
                          ),
                        ),
                        hintText: "Nombre del profesor",
                        hintStyle: TextStyle(
                          color: txtColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Color",
                          style: TextStyle(
                            color: txtColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                pickColors(context);
                              },
                              child: const Text(
                                "Selecciona un color",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          storeSubjectData();
                          //Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Guardar",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
