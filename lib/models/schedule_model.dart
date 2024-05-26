import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String subject;
  final DateTime from;
  final DateTime to;
  final String classroom;
  final String recurrenceRule;
  final String id;

  ScheduleModel({
    required this.subject,
    required this.from,
    required this.to,
    required this.classroom,
    required this.recurrenceRule,
    required this.id,
  });
    Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'from': from,
      'to': to,
      'classroom': classroom,
      'recurrenceRule': recurrenceRule,
      'id': id,
    };
  }
    factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      subject: map['subject'] ?? '',
      from: (map['from'] as Timestamp).toDate(),
      to: (map['to'] as Timestamp).toDate(),
      classroom: map['classroom'] ?? '',
      recurrenceRule: map['recurrenceRule'] ?? '',
      id: map['id'] ?? '',
    );
  }
}

