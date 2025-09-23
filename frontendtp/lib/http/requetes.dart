import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:frontendtp/class/requeteConnexion.dart';
import 'package:frontendtp/class/requeteInscription.dart';

import '../class/reponseConnexion.dart';

class SingletonDio {
  static var cookieManager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookieManager);
    return dio;
  }

  Future<ReponseConnexion> signin(RequeteConnexion req) async {
    try {
      var response = await SingletonDio.getDio()
          .post('http://10.0.2.2/id/connexion', data: req.toJson());
      print(response);
      return ReponseConnexion.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}