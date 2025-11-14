import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();*/

Future<void> setupFirebaseMessaging() async {
  /*await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        handleForegroundNotificationClick(response.payload!);
      }
    },
  );*/

  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onMessage.listen(_showNotification);

  FirebaseMessaging.onMessageOpenedApp
      .listen(handleBackgroundNotificationClick);

  FirebaseMessaging.instance
      .getInitialMessage()
      .then(handleBackgroundNotificationClick);
}

Future<void> _showNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;
  snackbarKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(notification.body ?? 'Vous avez reçu une notification.'),
      duration: const Duration(seconds: 3),
    ),
  );


  /*final androidDetails = AndroidNotificationDetails(
    'id_du_type_de_notifications',
    'Notifications générales',
    channelDescription: 'Notifications envoyées par le serveur',
    importance: Importance.high,
    priority: Priority.high,
  );

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title ?? 'Notification',
    notification.body ?? 'Vous avez reçu une notification.',
    NotificationDetails(android: androidDetails),
    payload: message.data["route"] ?? "",
  );*/


}

void handleForegroundNotificationClick(String payload) {
  debugPrint("Notification cliquée (foreground) : $payload");
}

void handleBackgroundNotificationClick(RemoteMessage? message) {
  if (message == null) return;
  debugPrint("Notification cliquée (background) : ${message.data}");
}