import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/models/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final scheduleRepositoryProvider = Provider(
  (ref) => ScheduleRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ScheduleRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ScheduleRepository({
    required this.firestore,
    required this.auth,
  });
  Future<List<ScheduleModel>> getAllScheduleData() async {
    String? uid = auth.currentUser?.uid;

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(uid!)
        .collection('schedules')
        .get();
    List<ScheduleModel> schedules = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ScheduleModel.fromMap(data);
    }).toList();
    return schedules;
  }

  Future<ScheduleModel?> getScheduleData(String scheduleId) async {
    var scheduleData = await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('schedules')
        .doc(scheduleId)
        .get();
    ScheduleModel? schedule;
    if (scheduleData.data() != null) {
      schedule = ScheduleModel.fromMap(scheduleData.data()!);
    }
    return schedule;
  }

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('schedules')
          .doc(scheduleId)
          .delete();
    } catch (e) {
      showSnackBar(content: e.toString());
    }
  }

  void saveScheduleData({
    required String subject,
    required DateTime from,
    required DateTime to,
    required String classroom,
    required String recurrenceRule,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var scheduleId = const Uuid().v1();
      var schedulem = ScheduleModel(
          subject: subject,
          from: from,
          to: to,
          classroom: classroom,
          recurrenceRule: recurrenceRule,
          id: scheduleId);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('schedules')
          .doc(scheduleId)
          .set(schedulem.toMap())
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(
                  initialTabIndex: 1,
                ),
              ),
              (route) => false));
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  void updateScheduleData({
    required String subject,
    required DateTime from,
    required DateTime to,
    required String classroom,
    required String recurrenceRule,
    required ProviderRef ref,
    required BuildContext context,
    required String id,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var schedulem = ScheduleModel(
          subject: subject,
          from: from,
          to: to,
          classroom: classroom,
          recurrenceRule: recurrenceRule,
          id: id);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('schedules')
          .doc(id)
          .update(schedulem.toMap())
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(
                  initialTabIndex: 1,
                ),
              ),
              (route) => false));
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}
