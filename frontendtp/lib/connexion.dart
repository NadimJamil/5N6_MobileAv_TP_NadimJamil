import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
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
  bool isLoading = false;

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

    try {
      setState(() {
        isLoading = true;
      });
      var req = RequeteConnexion(
        nom: email,
        motDePasse: password,
      );
      var reponse = await SingletonDio.getDio().post(
        "http://10.0.2.2:8080/id/connexion",
        data: req.toJson(),
      );
      var rep = ReponseConnexion.fromJson(reponse.data);
      print("Connexion réussie : ${rep.nomUtilisateur}");
      SessionUtilisateur().nomUtilisateur = rep.nomUtilisateur;
      navPageAccueuil();
      isLoading = false;
    }
    catch (e) {
      print("Erreur inscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de l'inscription")),
          );
          setState(() {
            isLoading = false;
          });
      }
      }

  Widget _buildPortraitLayout() {
    return Center(
      child: SingleChildScrollView(
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
            const SizedBox(height: 80),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
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
            const SizedBox(height: 32),
            const Text(
              "Vous n'avez pas de compte?",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: navPageInscription,
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: const Text(
                "S'inscrire",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Nom d'utilisateur",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      obscureText: true,
                      obscuringCharacter: '•',
                      textAlign: TextAlign.center,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  const Text(
                    "Vous n'avez pas de compte?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: navPageInscription,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent),
                    child: const Text(
                      "S'inscrire",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandscapeLayout();
          } else {
            return _buildPortraitLayout();
          }
        },
      ),
    );
  }
}