import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/events/controller/event_controller.dart';
import 'package:ca_mobile/features/events/repository/event_repository.dart';
import 'package:ca_mobile/features/events/screen/event_details.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_data_source.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends ConsumerStatefulWidget {
  const TasksWidget({super.key});

  @override
  ConsumerState<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends ConsumerState<TasksWidget>
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
    final date = ref.read(eventRepositoryProvider);
    final events = ref.read(eventControllerProvider);
    final selectedEvents = events.getEventsByDate();

    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgCalendar =
        tSwitchProvider ? const Color(0xFF12171D) : const Color(0xffede8e2);

    return FutureBuilder<List<EventModel>>(
      future: selectedEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<EventModel> eventsList = snapshot.data!;
          return SfCalendar(
            backgroundColor: bgCalendar,
            headerHeight: 0,
            todayHighlightColor: iconColor,
            view: CalendarView.timelineDay,
            dataSource: EventDataSource(eventsList),
            initialDisplayDate: date.selectedDay,
            viewHeaderStyle: ViewHeaderStyle(
              dateTextStyle: TextStyle(color: txtColor),
              dayTextStyle: TextStyle(color: txtColor),
            ),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeTextStyle: TextStyle(
                color: txtColor,
              ),
            ),
            appointmentBuilder: (context, calendarAppointmentDetails) {
              final event = calendarAppointmentDetails.appointments.first;

              return Container(
                width: calendarAppointmentDetails.bounds.width,
                height: calendarAppointmentDetails.bounds.height,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: txtColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            onTap: (calendarTapDetails) {
              if (calendarTapDetails.appointments == null) return;
              final event = calendarTapDetails.appointments!.first;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(event: event),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return ErrorScreen(error: "Error: ${snapshot.error}");
        }
        return const Loader();
      },
    );
  }
}
