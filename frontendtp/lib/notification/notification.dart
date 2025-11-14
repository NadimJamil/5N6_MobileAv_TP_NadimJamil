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
  final Dio _dio = Dio();
  String? _token;
  bool _isLoading = false;
  String _message = "Aucune action effectuée";

  @override
  void initState() {
    super.initState();
    recupToken();
  }

  Future<void> recupToken() async {
    setState(() {
      _isLoading = true;
      _message = "Récupération du token...";
    });

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        setState(() {
          _token = token;
        });

        await enregistrerJeton(token);
        print("Jeton enregistré : $token");
      } else {
        setState(() {
          _message = "Erreur : Token null";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Erreur lors de l'enregistrement : $e";
      });
      print("Erreur lors de l'enregistrement du jeton : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> enregistrerJeton(String token) async {
    try {
      final response = await _dio.post(
        '$apiUrl/enregistrer-jeton-notification',
        data: token,
        options: Options(headers: {'Content-Type': 'text/plain'}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _message = "✅ ${response.data}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "❌ Erreur: $e";
      });
      print("Erreur lors de l'enregistrement du jeton : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
