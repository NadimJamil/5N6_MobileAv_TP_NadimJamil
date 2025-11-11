import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  String apiUrl = "http://10.0.2.2:8080";
  recupToken() async{
    String? token = await FirebaseMessaging.instance.getToken();



  }

  Future<void> enregistrerJeton(String token) async {
    await Dio().post('$apiUrl/enregistrer-jeton-notification');
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
