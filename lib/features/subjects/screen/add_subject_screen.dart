import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
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
                        color: tSwitchProvider ? Colors.white : Colors.black,
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
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
                          ),
                        ),
                        hintText: "Nombre de la materia",
                        hintStyle: TextStyle(
                          color: tSwitchProvider ? Colors.white : Colors.black,
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
                        color: tSwitchProvider ? Colors.white : Colors.black,
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
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
                          ),
                        ),
                        hintText: "Nombre del profesor",
                        hintStyle: TextStyle(
                          color: tSwitchProvider ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
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
