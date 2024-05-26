import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String title;
  final DateTime from;
  final DateTime to;
  final String subject;
  final String description;
  final String type;
  final bool isDone;
  final String color;
  final String id;

  EventModel({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.type,
    required this.subject,
    required this.isDone,
    required this.color,
    required this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'type': type,
      'subject': subject,
      'isDone': isDone,
      'color': color,
      'id': id,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      from: (map['from'] as Timestamp).toDate(),
      to: (map['to'] as Timestamp).toDate(),
      type: map['type'] ?? '',
      subject: map['subject'] ?? '',
      isDone: map['isDone'] ?? '',
      color: map['color'] ?? '',
      id: map['id'] ?? '',
    );
  }
}

// List<Event> recentEvents = [
//   Event(
//     title: "Tarea 1",
//     //dueTime: DateTime.parse("2024-05-16"),
//     subject: 'Materia',
//     description: 'Descripción',
//   ),
//   Event(
//     title: "Tarea 1",
//     //dueTime: DateTime.parse("2024-05-16"),
//     subject: 'Materia',
//     description: 'Descripción',
//   ),
// ];
