import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with WidgetsBindingObserver {
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
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgCalendar =
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
          view: CalendarView.month,
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now(),
          backgroundColor: bgCalendar,
          headerStyle: CalendarHeaderStyle(
            backgroundColor: bgCalendar,
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
          todayHighlightColor: iconColor,
          showDatePickerButton: true,
          showNavigationArrow: true,
          showTodayButton: true,
        ),
      ),
    );
  }
}
