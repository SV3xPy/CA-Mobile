import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ca_mobile/features/events/controller/event_controller.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  static const routeName = '/add_event';
  final EventModel? event;
  const AddEventScreen({super.key, this.event});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen>
    with WidgetsBindingObserver {
  final eventTitleController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final typeController = TextEditingController();
  final allDatController = TextEditingController();
  final _formEventKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  String? _selectedSubject = "-----";
  String? _selectedType = "-----";
  int _selectedStatusID = -1;
  List<String> eventType = [
    "Tarea",
    "Examen",
    "Otro",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(
        const Duration(
          hours: 2,
        ),
      );
    }
    WidgetsBinding.instance.addObserver(this);
  }

  Future pickFromDateTime({
    required bool pickDate,
    required bool theme,
  }) async {
    final date = await pickDateTime(
      fromDate,
      pickDate: pickDate,
      theme: theme,
    );

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate, required bool theme}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate,
        firstDate: pickDate ? fromDate : null,
        theme: theme);

    if (date == null) return;

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
    required bool theme,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(1900),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: theme
                  ? const ColorScheme.dark(
                      primary: Color(0xFF63CF93),
                      onSurface: Colors.white,
                    )
                  : const ColorScheme.light(
                      primary: Color(0xFF9c306c),
                      onSurface: Colors.black,
                    ),
            ),
            child: child!,
          );
        },
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          initialDate,
        ),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );

      return date.add(time);
    }
  }

  void storeEventData() async {
    String title = eventTitleController.text.trim();
    fromDate;
    toDate;
    String subject = subjectController.text.trim();
    String type = typeController.text.trim();
    String color = 'FFFFFF';
    String description = 'prueba';
    if (title.isNotEmpty) {
      ref.read(eventControllerProvider).saveEventDataToFirebase(
          context, title, fromDate, toDate, subject, description, type, color);
    }
  }

  Future dummy() async {}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    eventTitleController.dispose();
    descriptionController.dispose();
    allDatController.dispose();
    fromController.dispose();
    toController.dispose();
    subjectController.dispose();
    typeController.dispose();
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
          "Nuevo evento",
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
                key: _formEventKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: eventTitleController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        color: txtColor,
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: "Por favor, ingresa un título.",
                          ),
                        ],
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          "Título",
                          style: TextStyle(
                            color: txtColor,
                          ),
                        ),
                        hintText: "Título del evento",
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
                          "Desde",
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
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: datetimeBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    Utils.toDate(fromDate),
                                    style: TextStyle(
                                      color: txtColor,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.calendar_month,
                                    color: iconColor,
                                  ),
                                  onTap: () {
                                    pickFromDateTime(
                                        pickDate: true, theme: tSwitchProvider);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: datetimeBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    Utils.toTime(fromDate),
                                    style: TextStyle(
                                      color: txtColor,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.timer_outlined,
                                    color: iconColor,
                                  ),
                                  onTap: () {
                                    pickFromDateTime(
                                      pickDate: false,
                                      theme: tSwitchProvider,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hasta",
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: datetimeBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    Utils.toDate(toDate),
                                    style: TextStyle(
                                      color: txtColor,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.calendar_month,
                                    color: iconColor,
                                  ),
                                  onTap: () {
                                    pickToDateTime(
                                      pickDate: true,
                                      theme: tSwitchProvider,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: datetimeBorder,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    Utils.toTime(toDate),
                                    style: TextStyle(
                                      color: txtColor,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.timer_outlined,
                                    color: iconColor,
                                  ),
                                  onTap: () {
                                    pickToDateTime(
                                        pickDate: false,
                                        theme: tSwitchProvider);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(
                              color: txtColor,
                            ),
                            decoration: InputDecoration(
                              label: Text(
                                "Materia",
                                style: TextStyle(
                                  color: txtColor,
                                ),
                              ),
                              hintText: _selectedSubject,
                              hintStyle: TextStyle(
                                color: txtColor,
                              ),
                              suffixIcon: FutureBuilder(
                                future:
                                    dummy(), //Cambiar por uno que recupere los datos de la materia.
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton<Subject>(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: iconColor,
                                      ),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Subject>>(
                                        (Subject value) {
                                          return DropdownMenuItem<Subject>(
                                            value: value,
                                            child: Text(
                                              "",
                                            ), //Colocar dentro del widget value.nombreMateria!
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (Subject? newValue) {
                                        /*
                                        _selectedSubject = newValue.nombreMateria
                                        subjectController.text = _selectedSubject*/
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  return Icon(
                                    Icons.keyboard_arrow_down,
                                    color: iconColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: typeController,
                            readOnly: true,
                            style: TextStyle(
                              color: txtColor,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: DropdownButton<String>(
                                padding: const EdgeInsets.only(
                                  right: 13.5,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: iconColor,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                items: eventType.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value;
                                    typeController.text = _selectedType!;
                                  });
                                },
                              ),
                              label: Text(
                                "Tipo",
                                style: TextStyle(
                                  color: txtColor,
                                ),
                              ),
                              hintText: _selectedType,
                              hintStyle: TextStyle(
                                color: txtColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: txtColor,
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          "Descripción",
                          style: TextStyle(
                            color: txtColor,
                          ),
                        ),
                        hintText: "Añade más detalles del evento",
                        hintStyle: TextStyle(
                          color: txtColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          storeEventData();
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
