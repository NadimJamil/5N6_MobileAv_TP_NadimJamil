import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/class/reponseAccueilItem.dart';
import 'package:frontendtp/class/reponseDetailTacheAvecPhoto.dart';

import '../class/reponseAccueilItemAvecPhoto.dart';
import '../class/tache.dart';
import '../generated/l10n.dart';

class CarteListe extends StatelessWidget {
  final Tache tache;
  final VoidCallback? onTap;

  const CarteListe({super.key, required this.tache, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    String? imageUrl = tache.imageUrl;
    return Card(
      color: Colors.blue,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tache.nomTache,
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
                        Text(
                          l10n.progressLabel,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "${tache.pourcentageAvancement}%",
                          style: const TextStyle(color: Colors.white),
                        ),
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
                        Text(
                          l10n.timeElapsedLabel,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "${tache.pourcentageTemps}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.deadlineLabel(tache.dateLimite.toString().split(' ')[0]),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white24,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.white54,
                      );
                    },
                  )
                      : const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}