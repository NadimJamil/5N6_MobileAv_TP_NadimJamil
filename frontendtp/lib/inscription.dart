import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/Connexion.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:frontendtp/auth/authentification.dart';
import 'package:frontendtp/class/reponseConnexion.dart';
import 'class/requeteInscription.dart';
import 'generated/l10n.dart';

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
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ' + user.email!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            navPageAccueuil();
          }
        });
      }
    }
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void navPageConnection({bool replace = false}) {
    if (!mounted) return;
    if (replace) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (context) => const LoginPage()));
    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => const LoginPage()));
    }
  }

  void navPageAccueuil({bool replace = true}) {
    if (!mounted) return;
    if (replace) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (context) => const HomePage()));
    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => const HomePage()));
    }
  }

  void reqInscription() async {
    setState(() {
      isLoading = true;
    });
    try {
      var req = RequeteInscription(
        nom: _usernameController.text.trim(),
        motDePasse: _passwordController.text.trim(),
        confirmationMotDePasse: _confirmPasswordController.text.trim(),
      );

      if (req.motDePasse != req.confirmationMotDePasse) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Les mots de passe ne correspondent pas."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await AuthService().signUp(email: req.nom, password: req.motDePasse);
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        navPageAccueuil(replace: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur d'authentification. Veuillez réessayer."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Erreur inscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).signupFailed)),
      );
    } finally{
      if(mounted){
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void reqInscriptionGoogle() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential? userCredential = await AuthService().signInWithGoogle();
      User? currentUser = userCredential?.user;
      print("Utilisateur connecté: ${currentUser?.email}");

      if (currentUser != null) {
        navPageAccueuil(replace: true);
        }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur d'authentification. Veuillez réessayer."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Erreur inscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).signupFailed)),
      );
    } finally{
      if(mounted){
        setState(() {
          isLoading = false;
        });
      }
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
                decoration: InputDecoration(
                  labelText: S.of(context).usernameHint,
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
                decoration: InputDecoration(
                  labelText: S.of(context).passwordHint,
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
                decoration: InputDecoration(
                  labelText: S.of(context).confirmPasswordHint,
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => reqInscriptionGoogle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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
              child: Text("Se connecter avec Google"),
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
              child: Text(S.of(context).continueBtn),
            ),
            const SizedBox(height: 32),
            Text(
              S.of(context).haveAccount,
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: navPageConnection,
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text(
                S.of(context).login,
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
                      decoration: InputDecoration(
                        labelText: S.of(context).usernameHint,
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
                      decoration: InputDecoration(
                        labelText: S.of(context).passwordHint,
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
                      decoration: InputDecoration(
                        labelText: S.of(context).confirmPasswordHint,
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
                    child: Text(S.of(context).continueBtn),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).haveAccount,
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: navPageConnection,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent),
                    child: Text(
                      S.of(context).login,
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
