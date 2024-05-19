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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 70,
        ),
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now(),
          backgroundColor: tSwitchProvider
              ? const Color(0xFF12171D)
              : const Color(0xffede8e2),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: tSwitchProvider
                ? const Color(0xFF12171D)
                : const Color(0xffede8e2),
            textStyle: TextStyle(
              color: tSwitchProvider ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dayTextStyle: TextStyle(
              color: tSwitchProvider ? Colors.white : Colors.black,
            ),
            dateTextStyle: TextStyle(
              color: tSwitchProvider ? Colors.white : Colors.black,
            ),
          ),
          cellBorderColor: tSwitchProvider ? Colors.white : Colors.black,
          timeSlotViewSettings: TimeSlotViewSettings(
            timeTextStyle: TextStyle(
              color: tSwitchProvider ? Colors.white : Colors.black,
            ),
            startHour: 0,
            endHour: 24,
          ),
          todayHighlightColor: tSwitchProvider
              ? const Color(0xFF63CF93)
              : const Color(0xFF9c306c),
          showDatePickerButton: true,
          showNavigationArrow: true,
          showTodayButton: true,
        ),
      ),
    );
  }
}
