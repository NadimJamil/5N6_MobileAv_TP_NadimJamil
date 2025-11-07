import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:frontendtp/class/reponseConnexion.dart';
import 'package:frontendtp/class/requeteConnexion.dart';
import 'package:frontendtp/inscription.dart';

import 'generated/l10n.dart';

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
        SnackBar(content: Text(S.of(context).signupFailed)),
          );
          setState(() {
            isLoading = false;
          });
      }
      }

  Widget _buildPortraitLayout(BuildContext context) {
    final l10n = S.of(context)!;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            Text(
              l10n.connectionTitle,
              style: const TextStyle(
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
                decoration: InputDecoration(
                  labelText: l10n.usernameLabel,
                  hintText: l10n.usernameHint,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
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
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  hintText: l10n.passwordHint,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
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
                padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(l10n.loginBtn),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.noAccount,
              style: const TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: navPageInscription,
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text(
                l10n.signUpLink,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final l10n = S.of(context)!;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    l10n.connectionTitle,
                    style: const TextStyle(
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
                      decoration: InputDecoration(
                        labelText: l10n.usernameLabel,
                        hintText: l10n.usernameHint,
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
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
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        hintText: l10n.passwordHint,
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
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
                    child: Text(l10n.loginBtn),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.noAccount,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: navPageInscription,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent),
                    child: Text(
                      l10n.signUpLink,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
            return _buildLandscapeLayout(context);
          } else {
            return _buildPortraitLayout(context);
          }
        },
      ),
    );
  }
}