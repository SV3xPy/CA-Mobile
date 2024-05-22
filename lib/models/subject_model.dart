import 'package:flutter/material.dart';

class Subject {
  final String subject;
  final String teacherName;
  final Color color;

  Subject({
    required this.color,
    required this.subject,
    required this.teacherName,
  });
}

List<Subject> subjects = [
  Subject(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  Subject(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  Subject(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  Subject(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
];
