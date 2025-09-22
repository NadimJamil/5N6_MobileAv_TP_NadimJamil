import 'package:flutter/material.dart';
import 'package:frontendtp/classExterne/designCarteListe.dart';
import 'package:frontendtp/consultation.dart';
import 'package:frontendtp/creation.dart';

import 'class/tache.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Connection";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tache? tache;
  List<Tache> listeTache = [
    Tache(
      nom: "A",
      avancement: 0,
      tempsEcoule: 0,
      dateLimite: DateTime(2025, 10, 1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      listeTache.add(Tache(nom:"Tache #$i",avancement: 0,tempsEcoule: 0,dateLimite: DateTime(2025, 10, 1)));
    }
  }

  void navCreation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const creation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Accueil"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: listeTache.length,
        itemBuilder: (context, index) {
          final selectedTache = listeTache[index];
          return CarteListe(
              tache: selectedTache,
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => consultation(tache: selectedTache),
                ),
              );
            },
          );
        },
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

