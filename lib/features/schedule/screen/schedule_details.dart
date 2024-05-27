import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDetailsScreen extends ConsumerWidget {
  static const routeName = '/schedule-details';
  final ScheduleModel schedule;

  const ScheduleDetailsScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    RecurrenceProperties recProp =
        SfCalendar.parseRRule(schedule.recurrenceRule, schedule.from);

    final Map<WeekDays, String> weekDayNames = {
      WeekDays.monday: 'Lunes',
      WeekDays.tuesday: 'Martes',
      WeekDays.wednesday: 'Miércoles',
      WeekDays.thursday: 'Jueves',
      WeekDays.friday: 'Viernes',
      WeekDays.saturday: 'Sábado',
      WeekDays.sunday: 'Domingo',
    };

    List<String> dayNames =
        recProp.weekDays.map((day) => weekDayNames[day]!).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles"),
        leading: const CloseButton(),
        actions: buildViewingActions(
          context,
          schedule,
          iconColor,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text(
            schedule.subject,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: txtColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            schedule.classroom,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: txtColor,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Desde",
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('EEE, MMM d, yyyy, HH:mm').format(schedule.from),
                style: TextStyle(
                  color: txtColor,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hasta",
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('EEE, MMM d, yyyy, HH:mm').format(schedule.to),
                style: TextStyle(
                  color: txtColor,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Repetición",
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                "$dayNames",
                style: TextStyle(
                  color: txtColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          // Text(
          //   event.description,
          //   style: TextStyle(
          //     color: txtColor,
          //     fontSize: 18,
          //   ),
          // ),
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(
    BuildContext context,
    ScheduleModel schedule,
    Color iconColor,
  ) {
    return [
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.edit,
          color: iconColor,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.delete,
          color: iconColor,
        ),
      ),
    ];
  }
}
