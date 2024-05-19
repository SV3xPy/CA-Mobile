class Event {
  final String title;
  final DateTime from;
  final DateTime to;
  final String subject;
  final String description;
  final String tipo;
  final bool isDone;
  final bool isAllDay;

  Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.tipo,
    required this.subject,
    required this.isDone,
    required this.isAllDay,
  });
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
