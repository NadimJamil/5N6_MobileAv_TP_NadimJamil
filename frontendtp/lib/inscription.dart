import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/Connexion.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:frontendtp/class/reponseConnexion.dart';
import 'class/requeteInscription.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void navPageConnection() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const LoginPage()));
  }

  @override
  void navPageAccueuil() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const HomePage()));
  }

  @override
  void reqInscription() async {
    try {
      setState(() {
        isLoading = true;
      });
      var req = RequeteInscription(
        nom: _usernameController.text.trim(),
        motDePasse: _passwordController.text.trim(),
        confirmationMotDePasse: _confirmPasswordController.text.trim(),
      );
      var reponse = await SingletonDio.getDio().post(
        "http://10.0.2.2:8080/id/inscription",
        data: req.toJson(),
      );

      print(reponse.data);
      var rep = ReponseConnexion.fromJson(reponse.data);
      print("Inscription réussie : ${rep.nomUtilisateur}");
      navPageAccueuil();
      isLoading = false;
    } catch (e) {
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
        title: const Text("Inscription"),
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

  Widget _buildPortraitLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            const Text(
              "Inscription",
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
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Entrez votre nom d'utilisateur",
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
                  labelText: "Entrez votre mot de passe",
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
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirmez votre mot de passe",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: reqInscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 64, vertical: 16),
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text("Continuer"),
            ),
            const SizedBox(height: 32),
            const Text(
              "Vous avez déjà un compte?",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: navPageConnection,
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: const Text(
                "Se connecter",
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
                    "Inscription",
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
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Entrez votre nom d'utilisateur",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
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
                        labelText: "Entrez votre mot de passe",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
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
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirmez votre mot de passe",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: reqInscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text("Continuer"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Vous avez déjà un compte?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: navPageConnection,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent),
                    child: const Text(
                      "Se connecter",
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
}
