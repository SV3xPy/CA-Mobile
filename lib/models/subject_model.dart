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
    // Asegúrate de que el valor hexadecimal tenga el prefijo 'FF' antes de convertirlo a un entero
    String colorHex = map['color'];
    if (!colorHex.startsWith('FF')) {
      colorHex = 'FF$colorHex'; // Agrega el prefijo 'FF' si no está presente
    }
    int? colorInt = int.tryParse(colorHex,
        radix: 16); // Usa radix: 16 para indicar que el string es hexadecimal
    Color? color = colorInt != null ? Color(colorInt) : Colors.white;
    return SubjectModel(
      subject: map['subject'] ?? '',
      teacherName: map['teacherName'] ?? '',
      color: color,
    );
  }
}
