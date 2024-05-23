import 'package:flutter/material.dart';

class SubjectModel {
  final String subject;
  final String teacherName;
  final Color color;

  SubjectModel({
    required this.color,
    required this.subject,
    required this.teacherName,
  });

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'teacherName': teacherName,
      'color': color.value.toRadixString(16).padLeft(8, '0'),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    int? colorInt = int.tryParse(map['color']);
    Color? color = colorInt != null ? Color(colorInt) : Colors.white;
    return SubjectModel(
      subject: map['subject'] ?? '',
      teacherName: map['teacherName'] ?? '',
      color: color,
    );
  }
}

List<SubjectModel> subjects = [
  SubjectModel(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  SubjectModel(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  SubjectModel(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
  SubjectModel(
    subject: "Math",
    teacherName: "Lauren Romanov",
    color: const Color(0xFF000000),
  ),
];
