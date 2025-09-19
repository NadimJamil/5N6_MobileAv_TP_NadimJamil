import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/Connexion.dart';
import 'package:frontendtp/accueuil.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

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
  void navPageConnection(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const LoginPage(),
        ),
    );
}

  @override
  void navPageAccueuil() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const HomePage()));
  }

  @override
  void requeteInscription() async{
    var reponse = await Dio().get("");
  }

  void connection(){
    final username = _usernameController.text.trim();
    final pw = _passwordController.text.trim();
    final pwConfirm = _confirmPasswordController.text.trim();

    if(!username.isEmpty && !pw.isEmpty && !pwConfirm.isEmpty){
      requeteInscription();
      navPageAccueuil();
    }
    else if(pwConfirm != pw){
      //error
    }
    else if(username.isEmpty || username.length < 4){
      //error
    }
    else if(pw.isEmpty || username.length < 7){
      //error
    }
    else if(pwConfirm.isEmpty || username.length < 7){
      //error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Inscription"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              "Inscription",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 150),
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Entrez votre nom d'utilisateur",
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '•',
                textAlign: TextAlign.center,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Entrez votre mot de passe",
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: true,
                obscuringCharacter: '•',
                textAlign: TextAlign.center,
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Entrez votre mot de passe",
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: connection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text("Continuer"),
            ),
            SizedBox(height: 32),
            Text(
                style: TextStyle(
                  color: Colors.white
                ),
                "Vous avez déja un compte?"),
            TextButton(onPressed: navPageConnection,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: Text(
                    "Se connecter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
            ),
      )
          ],
        ),
      ),
    );
  }
}
