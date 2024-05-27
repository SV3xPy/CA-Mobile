import 'package:ca_mobile/models/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<ScheduleModel> schedule) {
    appointments = schedule;
  }

  ScheduleModel getSchedule(int index) => appointments![index] as ScheduleModel;

  @override
  DateTime getStartTime(int index) => getSchedule(index).from;

  @override
  DateTime getEndTime(int index) => getSchedule(index).to;

  @override
  String getSubject(int index) => getSchedule(index).subject;

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  String getRecurrenceRule(int index) => getSchedule(index).recurrenceRule;
}
