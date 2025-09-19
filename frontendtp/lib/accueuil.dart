import 'package:flutter/material.dart';
import 'package:frontendtp/consultation.dart';
import 'package:frontendtp/creation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Connection";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> listeTache = ["A", "B", "C"];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      listeTache.add("Tache #$i");
    }
  }

  void navCreation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const creation(),
      ),
    );
  }

  void navConsultation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const consultation(),
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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: ListTile(
              title: Center(
                child: Text(
                  listeTache[index],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onTap: () {
                navConsultation();
              },
            ),
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
        elevation: 6, // shadow
        child: const Icon(
          Icons.add, // plus icon
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

