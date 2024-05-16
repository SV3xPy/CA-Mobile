class Event {
  final String title;
  final DateTime dueTime;
  final String? subject;
  final String? description;
  bool isDone = false;

  Event({
    required this.subject,
    required this.description,
    required this.title,
    required this.dueTime,
  });
}

List<Event> recentEvents = [
  Event(
    title: "Tarea 1",
    dueTime: DateTime.parse("2024-05-16"),
    subject: 'Materia',
    description: 'Descripción',
  ),
  Event(
    title: "Tarea 1",
    dueTime: DateTime.parse("2024-05-16"),
    subject: 'Materia',
    description: 'Descripción',
  ),
];
