import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/common/widgets/subjects_list.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final subjectRepositoryProvider = Provider(
  (ref) => SubjectRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class SubjectRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SubjectRepository({
    required this.firestore,
    required this.auth,
  });
  Future<List<SubjectModel>> getAllSubjectsData() async {
    // Obtén el UID del usuario actual
    String? uid = auth.currentUser?.uid;

    // Realiza una consulta para obtener todos los documentos de la colección 'subjects' bajo el documento del usuario
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(uid!)
        .collection('subjects')
        .get();

    // Mapea cada documento de la respuesta a un SubjectModel
    List<SubjectModel> subjects = querySnapshot.docs.map((doc) {
      // Asegúrate de que los datos del documento sean un Map<String, dynamic>
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Crea un SubjectModel a partir de los datos del documento
      return SubjectModel.fromMap(data);
    }).toList();

    return subjects;
  }

  Stream<List<SubjectModel>> getAllSubjectsDataStream() {
    // Obtén el UID del usuario actual
    String? uid = auth.currentUser?.uid;

    // Retorna un Stream que emite una lista de SubjectModel cada vez que la colección cambia
    return firestore
        .collection('users')
        .doc(uid!)
        .collection('subjects')
        .snapshots()
        .map((querySnapshot) {
      // Mapea cada documento de la respuesta a un SubjectModel
      return querySnapshot.docs.map((doc) {
        // Asegúrate de que los datos del documento sean un Map<String, dynamic>
        Map<String, dynamic> data = doc.data();
        // Crea un SubjectModel a partir de los datos del documento
        return SubjectModel.fromMap(data);
      }).toList();
    });
  }

  Future<SubjectModel?> getSubjectData(String subjectId) async {
    //Falta ponerle algo al doc para que traiga los datos de un evento en especifico
    var subjectData = await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('subjects')
        .doc(subjectId)
        .get();
    SubjectModel? subject;
    if (subjectData.data() != null) {
      subject = SubjectModel.fromMap(subjectData.data()!);
    }
    return subject;
  }

  Future<void> deleteSubject(String subjectId) async {
    // Elimina el documento específico de la colección 'subjects'
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('subjects')
        .doc(subjectId)
        .delete();
  }

  void saveSubjectData({
    required String subject,
    required String teacherName,
    required Color color,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var subjectId = const Uuid().v1();
      var subjectm = SubjectModel(
          teacherName: teacherName,
          subject: subject,
          color: color,
          id: subjectId);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('subjects')
          .doc(subjectId)
          .set(subjectm.toMap())
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(
                  initialTabIndex: 2,
                ),
              ),
              (route) => false));
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  void updateSubjectData({
    required String subject,
    required String teacherName,
    required Color color,
    required ProviderRef ref,
    required BuildContext context,
    required String id,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var subjectm = SubjectModel(
          color: color, subject: subject, teacherName: teacherName, id: id);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('subjects')
          .doc(id)
          .update(subjectm.toMap())
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(
                  initialTabIndex: 2,
                ),
              ),
              (route) => false));
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            context: context, content: e.toString()); // Manejo de errores
      }
    }
  }
}
