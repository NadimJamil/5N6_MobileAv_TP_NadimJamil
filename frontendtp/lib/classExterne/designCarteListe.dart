import 'package:flutter/material.dart';

import '../class/tache.dart';

class CarteListe extends StatelessWidget {
  final Tache tache;
  final VoidCallback? onTap;

  const CarteListe({super.key, required this.tache, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom
              Text(
                tache.nom,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Avancement", style: TextStyle(color: Colors.white70)),
                  Text("${tache.avancement}%", style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: tache.avancement / 100,
                backgroundColor: Colors.white24,
                color: Colors.greenAccent,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),

              const SizedBox(height: 12),

              // Temps écoulé
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Temps écoulé", style: TextStyle(color: Colors.white70)),
                  Text("${tache.tempsEcoule}%", style: const TextStyle(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 12),

              // Deadline
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    "Deadline: ${tache.dateLimite.toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
