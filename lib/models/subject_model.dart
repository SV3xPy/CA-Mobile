class Subject {
  final String subject;
  final String type;
  final String teacherName;
  final DateTime time;
  bool isPassed = false;
  bool isHappening = false;

  Subject({
    required this.subject,
    required this.type,
    required this.teacherName,
    required this.time,
  });
}

List<Subject> subjects = [
  Subject(
    subject: "Math",
    type: "Online Class",
    teacherName: "Lauren Romanov",
    time: DateTime.now(),
  ),
  Subject(
    subject: "Math",
    type: "Online Class",
    teacherName: "Lauren Romanov",
    time: DateTime.now(),
  ),
  Subject(
    subject: "Math",
    type: "Online Class",
    teacherName: "Lauren Romanov",
    time: DateTime.now(),
  ),
  Subject(
    subject: "Math",
    type: "Online Class",
    teacherName: "Lauren Romanov",
    time: DateTime.now(),
  ),
];
