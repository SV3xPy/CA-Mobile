import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final eventRepositoryProvider = Provider(
  (ref) => EventRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class EventRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  EventRepository({
    required this.firestore,
    required this.auth,
  });

  Future<EventModel?> getEventData() async {
    //Falta ponerle algo al doc para que traiga los datos de un evento en especifico
    var eventData =
        await firestore.collection('users').doc(auth.currentUser?.uid).collection('events').doc().get();
    EventModel? event;
    if (eventData.data() != null) {
      event = EventModel.fromMap(eventData.data()!);
    }
    return event;
  }
  Future<void> deleteEvent() async {

  }
  void saveEventData({
    required String title,
    required DateTime from,
    required DateTime to,
    required String subject,
    required String description,
    required String type,
    required String color,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var eventId = const Uuid().v1();
      var event = EventModel(
          title: title,
          description: description,
          from: from,
          to: to,
          type: type,
          subject: subject,
          color:color,
          isDone: false);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('events')
          .doc(eventId)
          .set(event.toMap())
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(),
              ),
              (route) => false));
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}
