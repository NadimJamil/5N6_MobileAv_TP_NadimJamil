import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:frontendtp/class/reponseConnexion.dart';
import 'package:frontendtp/class/requeteConnexion.dart';
import 'package:frontendtp/inscription.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  final String title = "Connection";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void navPageInscription() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const SignUpPage()));
  }

  @override
  void navPageAccueuil() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const HomePage()));
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      var req = RequeteConnexion(
        nom: email,
        motDePasse: password,
      );
      var reponse = await dio.post(
        "http://10.0.2.2:8080/id/connexion",
        data: req.toJson(),
      );
      var rep = ReponseConnexion.fromJson(reponse.data);
      print("Connexion réussie : ${rep.nomUtilisateur}");
      navPageAccueuil();
    }
    catch (e) {
      print("Erreur inscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de l'inscription")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            const Text(
              "Connexion",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 250),
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Nom d'utilisateur",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '•',
                textAlign: TextAlign.center,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text("Se connecter"),
            ),
            SizedBox(height: 32),
            Text(
              style: TextStyle(color: Colors.white),
              "Vous n'avez pas de compte?",
            ),
            TextButton(
              onPressed: navPageInscription,
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text(
                "S'inscrire",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
