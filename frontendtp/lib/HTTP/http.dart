import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

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

  factory SessionUtilisateur() {
    return _instance;
  }

  SessionUtilisateur._internal();
}