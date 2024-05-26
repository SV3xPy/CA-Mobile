import 'package:ca_mobile/features/subjects/repository/subject_repository.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectControllerProvider = Provider((ref) {
  final subjectRepository = ref.watch(subjectRepositoryProvider);
  return SubjectController(subjectRepository: subjectRepository, ref: ref);
});

class SubjectController {
  final SubjectRepository subjectRepository;
  final ProviderRef ref;

  SubjectController({
    required this.subjectRepository,
    required this.ref,
  });
  Future<SubjectModel?> getSubjectData(String subjectId) async {
    SubjectModel? subject = await subjectRepository.getSubjectData(subjectId);
    return subject;
  }

  Future<List<SubjectModel>> getAllSubjectData() async {
    List<SubjectModel> subjects = await subjectRepository.getAllSubjectsData();
    return subjects;
  }

  Stream<List<SubjectModel>> getAllSubjectDataStream() {
    return subjectRepository.getAllSubjectsDataStream();
  }

  Future<void> deleteSubject(String subjectId) async {
    await subjectRepository.deleteSubject(subjectId);
  }

  void saveSubjectDataToFirebase(
      BuildContext context, String subject, String teacherName, Color color) {
    subjectRepository.saveSubjectData(
        subject: subject,
        teacherName: teacherName,
        color: color,
        ref: ref,
        context: context);
  }

  void updateSubjectDataToFirebase(BuildContext context, String subject,
      String teacherName, Color color, String id) {
    subjectRepository.updateSubjectData(
      subject: subject,
      teacherName: teacherName,
      color: color,
      ref: ref,
      context: context,
      id: id,
    );
  }
}
