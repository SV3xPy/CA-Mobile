import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class _AddScheduleScreenState extends ConsumerStatefulWidget {
  static const routeName = '/add_schedule';
  final Schedule? schedule;
  const _AddScheduleScreenState({
    this.schedule,
    super.key,
  });

  @override
  ConsumerState<_AddScheduleScreenState> createState() =>
      __AddScheduleScreenStateState();
}

class __AddScheduleScreenStateState
    extends ConsumerState<_AddScheduleScreenState> with WidgetsBindingObserver {
  final dayController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final subjectController = TextEditingController();
  final classroomController = TextEditingController();
  final _formScheduleKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  String? _selectedSubject = "-----";
  String? _selectedDay = "-----";
  int _selectedStatusID = -1;

  final List<String> dayNames = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  // List<int> day = [
  //   DateTime.monday,
  //   DateTime.tuesday,
  //   DateTime.wednesday,
  //   DateTime.thursday,
  //   DateTime.friday,
  //   DateTime.saturday,
  //   DateTime.sunday,
  // ];

  // Map<int, String> dayNames = {
  //   DateTime.monday: 'Monday',
  //   DateTime.tuesday: 'Tuesday',
  //   DateTime.wednesday: 'Wednesday',
  //   DateTime.thursday: 'Thursday',
  //   DateTime.friday: 'Friday',
  //   DateTime.saturday: 'Saturday',
  //   DateTime.sunday: 'Sunday',
  // };

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

  Future dummy() async {}

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final datetimeBorder =
        tSwitchProvider ? const Color(0xFFBE9020) : Colors.black12;
    final a = DateFormat.DAY;

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
                            controller: dayController,
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
                                items: dayNames.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedDay = value;
                                    dayController.text = _selectedSubject!;
                                  });
                                },
                              ),
                              label: Text(
                                "Día",
                                style: TextStyle(
                                  color: txtColor,
                                ),
                              ),
                              hintText: _selectedSubject,
                              hintStyle: TextStyle(
                                color: txtColor,
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
                                    return DropdownButton<Schedule>(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: iconColor,
                                      ),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Schedule>>(
                                        (Schedule value) {
                                          return DropdownMenuItem<Schedule>(
                                            value: value,
                                            child: Text(
                                              "",
                                            ), //Colocar dentro del widget value.nombreMateria!
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (Schedule? newValue) {
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
