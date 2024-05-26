class ScheduleModel {
  final String subject;
  final DateTime from;
  final DateTime to;
  final String classroom;
  final String recurrenceRule;

  ScheduleModel({
    required this.subject,
    required this.from,
    required this.to,
    required this.classroom,
    required this.recurrenceRule,
  });
}
