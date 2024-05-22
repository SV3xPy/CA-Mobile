import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
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
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final datetimeBorder =
        tSwitchProvider ? const Color(0xFF12171D) : const Color(0xffede8e2);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 60.0,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AddEventScreen.routeName,
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 70,
        ),
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now(),
          backgroundColor: datetimeBorder,
          headerStyle: CalendarHeaderStyle(
            backgroundColor: datetimeBorder,
            textStyle: TextStyle(
              color: txtColor,
            ),
            textAlign: TextAlign.center,
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dayTextStyle: TextStyle(
              color: txtColor,
            ),
            dateTextStyle: TextStyle(
              color: txtColor,
            ),
          ),
          cellBorderColor: txtColor,
          timeSlotViewSettings: TimeSlotViewSettings(
            timeTextStyle: TextStyle(
              color: txtColor,
            ),
            startHour: 0,
            endHour: 24,
          ),
          todayHighlightColor: iconColor,
          showDatePickerButton: true,
          showNavigationArrow: true,
          showTodayButton: true,
        ),
      ),
    );
  }
}
