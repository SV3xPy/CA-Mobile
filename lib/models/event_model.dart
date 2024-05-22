class EventModel {
  final String title;
  final DateTime from;
  final DateTime to;
  final String subject;
  final String description;
  final String type;
  final bool isDone;

  EventModel({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.type,
    required this.subject,
    required this.isDone,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'type': type,
      'subject': subject,
      'isDone': isDone
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      type: map['type'] ?? '',
      subject: map['subject'] ?? '',
      isDone: map['isDone'] ?? ''
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
