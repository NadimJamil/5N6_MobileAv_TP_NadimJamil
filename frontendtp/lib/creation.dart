import 'package:flutter/material.dart';

class creation extends StatefulWidget {
  const creation({super.key});

  final String title = "Création";

  @override
  State<creation> createState() => _creationState();
}

class _creationState extends State<creation> {
  final TextEditingController _nomTacheController = TextEditingController();

  @override
  void dispose() {
    _nomTacheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _nomTacheController,
                decoration: const InputDecoration(
                  labelText: "Nom de la tâche",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
