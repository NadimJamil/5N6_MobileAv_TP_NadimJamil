import 'package:flutter/material.dart';

class consultation extends StatefulWidget {
  const consultation({super.key});

  final String title = "Consultation";
  @override
  State<consultation> createState() => _consultationState();
}

class _consultationState extends State<consultation> {
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
            Text("Tache #1")
          ],
        ),
      ),
    );
  }
}
