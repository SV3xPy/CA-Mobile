import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> subscribeToTopics(List<String> topics) async {
    for (var topic in topics) {
      await _firebaseMessaging.subscribeToTopic(topic);
    }
  }

  Future<void> unsubscribeFromTopics(List<String> topics) async {
    for (var topic in topics) {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }
}
