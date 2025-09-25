import 'package:flutter/material.dart';
import 'package:frontendtp/class/reponseAccueilItem.dart';

import '../class/tache.dart';

class CarteListe extends StatelessWidget {
  final ReponseAccueilItem tache;
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
                  Text("${tache.pourcentageAvancement}%", style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: tache.pourcentageAvancement / 100,
                backgroundColor: Colors.white24,
                color: Colors.greenAccent,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Temps écoulé", style: TextStyle(color: Colors.white70)),
                  Text("${tache.pourcentageTemps}%", style: const TextStyle(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 12),
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
