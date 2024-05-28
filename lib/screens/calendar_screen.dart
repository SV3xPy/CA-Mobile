import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/common/widgets/tasks_widgets.dart';
import 'package:ca_mobile/features/events/controller/event_controller.dart';
import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_data_source.dart';
import 'package:ca_mobile/models/event_model.dart';
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
    final eventCont = ref.read(eventControllerProvider);
    final events = ref.read(eventControllerProvider).getAllEventsData();
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
        child: FutureBuilder(
          future: events,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> events = snapshot.data!;
              return SfCalendar(
                view: CalendarView.month,
                dataSource: EventDataSource(events),
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                backgroundColor: bgCalendar,
                monthViewSettings: MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(
                      color: txtColor,
                    ),
                  ),
                ),
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
                onLongPress: (calendarLongPressDetails) {
                  eventCont.setDate(calendarLongPressDetails.date!);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const TasksWidget(),
                  );
                },
              );
            } else if (snapshot.hasError) {
              print("$snapshot");
              return ErrorScreen(error: "${snapshot.error}");
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}
