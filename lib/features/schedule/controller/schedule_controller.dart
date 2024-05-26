import 'package:ca_mobile/features/schedule/repository/schedule_repository.dart';
import 'package:ca_mobile/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleControllerProvider = Provider((ref) {
  final scheduleRepository = ref.watch(scheduleRepositoryProvider);
  return ScheduleController(scheduleRepository: scheduleRepository, ref: ref);
});

class ScheduleController {
  final ScheduleRepository scheduleRepository;
  final ProviderRef ref;

  ScheduleController({
    required this.scheduleRepository,
    required this.ref,
  });
  Future<ScheduleModel?> getScheduleData(String scheduleId) async {
    ScheduleModel? schedule =
        await scheduleRepository.getScheduleData(scheduleId);
    return schedule;
  }

  Future<List<ScheduleModel>> getAllScheduleData() async {
    List<ScheduleModel> schedules =
        await scheduleRepository.getAllScheduleData();
    return schedules;
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await scheduleRepository.deleteSchedule(scheduleId);
  }

  void saveScheduleDataToFirebase(BuildContext context, String subject,
      DateTime from, DateTime to, String classroom, String recurrenceRule) {
    scheduleRepository.saveScheduleData(
        subject: subject,
        from: from,
        to: to,
        classroom: classroom,
        recurrenceRule: recurrenceRule,
        ref: ref,
        context: context);
  }

  void updateSubjectDataToFirebase(
      BuildContext context,
      String subject,
      DateTime from,
      DateTime to,
      String classroom,
      String recurrenceRule,
      String id) {
    scheduleRepository.updateScheduleData(
        subject: subject,
        from: from,
        to: to,
        classroom: classroom,
        recurrenceRule: recurrenceRule,
        ref: ref,
        context: context,
        id: id);
  }
}
