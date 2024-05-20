class ClassModel {
  final String uid;
  final String name;
  final String clave;
  final String docente;
  final String correoDocente;
  final List<Map<String, String>> schedules;

  ClassModel({
    required this.uid,
    required this.name,
    required this.clave,
    required this.docente,
    required this.correoDocente,
    required this.schedules,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'clave': clave,
      'docente': docente,
      'correoDocente': correoDocente,
      'schedules': schedules,
    };
  }

factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      clave: map['clave'] ?? '',
      docente: map['docente'] ?? '',
      correoDocente: map['correoDocente'] ?? '',
      schedules: List<Map<String, String>>.from(map['schedules'] ?? []),
    );
  }
}