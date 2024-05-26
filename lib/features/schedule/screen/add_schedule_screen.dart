import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/features/schedule/controller/schedule_controller.dart';
import 'package:ca_mobile/features/subjects/controller/subject_controller.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/schedule_model.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = '/add_schedule';
  final ScheduleModel? schedule;
  const AddScheduleScreen({super.key, this.schedule});

  @override
  ConsumerState<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends ConsumerState<AddScheduleScreen>
    with WidgetsBindingObserver {
  final subjectController = TextEditingController();
  final classroomController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final daysController = TextEditingController();
  String? _selectedSubject = "-----";
  String? _noDays = "-----";
  List<String> _selectedDays = [];
  String? until;
  String? byDay;
  String? recurrenceRule;
  late DateTime fromDate;
  late DateTime toDate;
  final _formScheduleKey = GlobalKey<FormState>();
  final List<String> _daysWeek = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo",
  ];
  final Map<String, String> _daysMap = {
    "Lunes": "MO",
    "Martes": "TU",
    "Miércoles": "WE",
    "Jueves": "TH",
    "Viernes": "FR",
    "Sábado": "SA",
    "Domingo": "SU"
  };

  @override
  void initState() {
    super.initState();
    if (widget.schedule == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(
        const Duration(
          hours: 2,
        ),
      );
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

  Future<void> _dialogBuilder(
    Color? bg,
    Color txt,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bg,
          title: Text(
            "Seleccionar días",
            style: TextStyle(
              color: txt,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: _daysWeek.map(
                    (day) {
                      return CheckboxListTile(
                        title: Text(
                          day,
                          style: TextStyle(color: txt),
                        ),
                        value: _selectedDays.contains(day),
                        onChanged: (bool? value) {
                          setState(
                            () {
                              if (value == true) {
                                if (!_selectedDays.contains(day)) {
                                  _selectedDays.add(day);
                                }
                              } else {
                                _selectedDays.remove(day);
                              }
                              daysController.text = _selectedDays.join(', ');
                            },
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(txt),
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void storeScheduleData() async {
    fromDate;
    toDate;
    String subject = subjectController.text.trim();
    String classroom = classroomController.text.trim();
    String recurrenceRule = daysController.text.trim();
    if (subject.isNotEmpty) {
      ref.read(scheduleControllerProvider).saveScheduleDataToFirebase(
          context, subject,fromDate,toDate,classroom,recurrenceRule);
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
          "Nuevo horario",
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
                key: _formScheduleKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: subjectController,
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
                                future: ref
                                    .read(subjectControllerProvider)
                                    .getAllSubjectData(), //Cambiar por uno que recupere los datos de la materia.
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton<SubjectModel>(
                                      padding: const EdgeInsets.only(
                                        right: 13,
                                      ),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: iconColor,
                                      ),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<SubjectModel>>(
                                        (SubjectModel value) {
                                          return DropdownMenuItem<SubjectModel>(
                                            value: value,
                                            child: Text(
                                              value.subject,
                                            ), //Colocar dentro del widget value.nombreMateria!
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (SubjectModel? newValue) {
                                        _selectedSubject = newValue!.subject;
                                        subjectController.text =
                                            _selectedSubject!;
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
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: classroomController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        color: txtColor,
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: "Por favor, ingresa el salón.",
                          ),
                        ],
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          "Aula",
                          style: TextStyle(
                            color: txtColor,
                          ),
                        ),
                        hintText: "Nombre del aula",
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
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: daysController,
                          readOnly: true,
                          style: TextStyle(
                            color: txtColor,
                          ),
                          decoration: InputDecoration(
                            label: Text(
                              "Días a repetir",
                              style: TextStyle(
                                color: txtColor,
                              ),
                            ),
                            hintText: _noDays,
                            hintStyle: TextStyle(
                              color: txtColor,
                            ),
                          ),
                          onTap: () {
                            _dialogBuilder(bgColor, txtColor);
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              List<String> abbreviatedDays = _selectedDays
                                  .map((day) => _daysMap[day]!)
                                  .toList();
                              byDay = abbreviatedDays.join(',');
                              until = Utils.formatDateToISO(toDate);
                              recurrenceRule =
                                  "FREQ=WEEKLY;INTERVAL=1;BYDAY=$byDay;UNTIL=$until";
                              print(abbreviatedDays);
                              print(byDay);
                              print(toDate);
                              print(until);
                              print(recurrenceRule);
                              storeScheduleData();
                            },
                            child: const Text(
                              "Guardar",
                            ),
                          ),
                        ),
                      ],
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
