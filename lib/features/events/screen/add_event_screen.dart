import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  static const routeName = '/add_event';
  final Event? event;
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

  Future dummy() async {}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     helpText: "Seleccióna la fecha",
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       birthDayController.text =
  //           "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
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
                        color: tSwitchProvider ? Colors.white : Colors.black,
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
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
                          ),
                        ),
                        hintText: "Título del evento",
                        hintStyle: TextStyle(
                          color: tSwitchProvider ? Colors.white : Colors.black,
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
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
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
                                    color: tSwitchProvider
                                        ? const Color(0xFFBE9020)
                                        : Colors.black12,
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
                                      color: tSwitchProvider
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.calendar_month,
                                    color: tSwitchProvider
                                        ? const Color(0xFF63CF93)
                                        : const Color(0xFF9c306c),
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
                                    color: tSwitchProvider
                                        ? const Color(0xFFBE9020)
                                        : Colors.black12,
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
                                      color: tSwitchProvider
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.timer_outlined,
                                    color: tSwitchProvider
                                        ? const Color(0xFF63CF93)
                                        : const Color(0xFF9c306c),
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
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
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
                                    color: tSwitchProvider
                                        ? const Color(0xFFBE9020)
                                        : Colors.black12,
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
                                      color: tSwitchProvider
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.calendar_month,
                                    color: tSwitchProvider
                                        ? const Color(0xFF63CF93)
                                        : const Color(0xFF9c306c),
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
                                    color: tSwitchProvider
                                        ? const Color(0xFFBE9020)
                                        : Colors.black12,
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
                                      color: tSwitchProvider
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.timer_outlined,
                                    color: tSwitchProvider
                                        ? const Color(0xFF63CF93)
                                        : const Color(0xFF9c306c),
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
                              color:
                                  tSwitchProvider ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              label: Text(
                                "Materia",
                                style: TextStyle(
                                  color: tSwitchProvider
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              hintText: _selectedSubject,
                              hintStyle: TextStyle(
                                color: tSwitchProvider
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              suffixIcon: FutureBuilder(
                                future:
                                    dummy(), //Cambiar por uno que recupere los datos de la materia.
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton<Subject>(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: tSwitchProvider
                                            ? const Color(0xFF63CF93)
                                            : const Color(0xFF9c306c),
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
                                    color: tSwitchProvider
                                        ? const Color(0xFF63CF93)
                                        : const Color(0xFF9c306c),
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
                              color:
                                  tSwitchProvider ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: DropdownButton<String>(
                                padding: const EdgeInsets.only(
                                  right: 13.5,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: tSwitchProvider
                                      ? const Color(0xFF63CF93)
                                      : const Color(0xFF9c306c),
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
                                  color: tSwitchProvider
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              hintText: _selectedType,
                              hintStyle: TextStyle(
                                color: tSwitchProvider
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
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
