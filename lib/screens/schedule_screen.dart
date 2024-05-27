import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/schedule/controller/schedule_controller.dart';
import 'package:ca_mobile/features/schedule/screen/add_schedule_screen.dart';
import 'package:ca_mobile/features/schedule/screen/schedule_details.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/schedule_data_source.dart';
import 'package:ca_mobile/models/schedule_model.dart';
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Map<String, ScheduleModel> mapSchedulesById(
    List<ScheduleModel> schedulesList,
  ) {
    return {for (var schedule in schedulesList) schedule.id: schedule};
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final datetimeBorder =
        tSwitchProvider ? const Color(0xFF12171D) : const Color(0xffede8e2);

    final scheduleProvider = ref.read(scheduleControllerProvider);
    final schedules = scheduleProvider.getAllScheduleData();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 60.0,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AddScheduleScreen.routeName,
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
        child: FutureBuilder<List<ScheduleModel>>(
          future: schedules,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ScheduleModel> schedulesList = snapshot.data!;

              return SfCalendar(
                view: CalendarView.week,
                dataSource: ScheduleDataSource(schedulesList),
                appointmentBuilder: (context, calendarAppointmentDetails) {
                  final schedule =
                      calendarAppointmentDetails.appointments.first;
                  return Container(
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        schedule.subject,
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
                firstDayOfWeek: 1,
                headerHeight: 0,
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
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.appointments == null) return;
                  final schedule = calendarTapDetails.appointments!.first;
                  Map<String, ScheduleModel> schedulesMap =
                      mapSchedulesById(schedulesList);
                  ScheduleModel? scheduleModel = schedulesMap['${schedule.id}'];
                  // if (schedule != null) {
                  //   // El schedule con el ID especificado fue encontrado
                  //   print(scheduleModel!.subject);
                  // } else {
                  //   // El schedule con el ID especificado no fue encontrado
                  //   print('Schedule not found');
                  // }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ScheduleDetailsScreen(schedule: scheduleModel!),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return ErrorScreen(error: "${snapshot.error}");
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}
