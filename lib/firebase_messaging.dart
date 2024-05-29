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

  Future<void> subscribeToTopics(String topic) async {
      await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopics(String topic) async {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    //final fCMToken = await _firebaseMessaging.getToken();
    initPushNotifications();
  }
}
