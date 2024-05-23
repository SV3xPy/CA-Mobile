class AnnotationModel {
  final String uid;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool notificacion;
  final String descripcion;
  final String uidUsuario;

  AnnotationModel({
    required this.uid,
    required this.fechaInicio,
    required this.fechaFin,
    required this.notificacion,
    required this.descripcion,
    required this.uidUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'notificacion': notificacion,
      'descripcion': descripcion,
      'uidUsuario': uidUsuario,
    };
  }

  factory AnnotationModel.fromMap(Map<String, dynamic> map) {
    return AnnotationModel(
      uid: map['uid'] ?? '',
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      notificacion: map['notificacion'] ?? false,
      descripcion: map['descripcion'] ?? '',
      uidUsuario: map['uidUsuario'] ?? '',
    );
  }
}
