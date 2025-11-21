import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SingletonDio {
  static var cookieManager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookieManager);
    //dio.options.baseUrl = "http://10.0.2.2:8080";
    return dio;
  }
}

class SessionUtilisateur {
  static final SessionUtilisateur _instance = SessionUtilisateur._internal();
  String? nomUtilisateur;
  String? email;
  String? photoURL;

  factory SessionUtilisateur() {
    return _instance;
  }

  SessionUtilisateur._internal();
  void initFromFirebaseUser(User? user) {
    if (user != null) {
      nomUtilisateur = user.displayName;
      email = user.email;
      photoURL = user.photoURL;
    }
  }

  void refreshFromFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    initFromFirebaseUser(user);
  }

  void clear() {
    nomUtilisateur = null;
    email = null;
    photoURL = null;
  }
}