class Alert {
  final String title;
  final String subject;
  final DateTime time;

  Alert({
    required this.title,
    required this.subject,
    required this.time,
  });
}

List<Alert> recentAlerts = [
  Alert(
    title: "Math Test",
    subject: "Trigonometry",
    time: DateTime.parse("2024-05-20 12:30:00"),
  ),
  Alert(
    title: "Math Test",
    subject: "Trigonometry",
    time: DateTime.now(),
  )
];
