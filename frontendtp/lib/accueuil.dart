import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/classExterne/designCarteListe.dart';
import 'package:frontendtp/consultation.dart';
import 'package:frontendtp/creation.dart';
import 'package:path_provider/path_provider.dart';

import 'class/tache.dart';
import 'class/reponseAccueilItem.dart';
import 'inscription.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Connection";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Tache? tache;
  List<ReponseAccueilItem> listeTache = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    requeteListeTache();
  }

  void navCreation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const creation(),
      ),
    );
  }

  Future<void> deconnexion(BuildContext context) async {
    try {

      final response = await SingletonDio.getDio().post('http://10.0.2.2:8080/id/deconnexion');
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignUpPage()),
              (route) => false,
        );
      } else {
        print("Erreur lors de la déconnexion : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de connexion au serveur : $e");
    }
  }

  void requeteListeTache() async {
    try {
      var reponse = await SingletonDio.getDio().get(
          "http://10.0.2.2:8080/tache/accueil"
      );
      List<dynamic> jsonList = reponse.data;
      if(jsonList != null){
        print("Liste des tâches reçue : $jsonList");
        this.listeTache = jsonList.map((json) => ReponseAccueilItem.fromJson(json)).toList();
      }

      setState(() {});
    }
    catch (e) {
      print("Erreur de chargement: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur d'affichage de liste")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Accueil"),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: listeTache.length,
          itemBuilder: (context, index) {
            final selectedTache = listeTache[index];
            return CarteListe(
                tache: selectedTache,
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => Consultation(tache: selectedTache),
                  ),
                );
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
              ),
            ),
            ListTile(
              title: const Text('Accueil'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Création de tâche'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const creation(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                deconnexion(context);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navCreation();
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 6,
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

