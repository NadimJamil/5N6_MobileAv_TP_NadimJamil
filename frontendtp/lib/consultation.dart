import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/class/reponseAccueilItem.dart';

import 'accueuil.dart';
import 'class/tache.dart';
import 'creation.dart';
import 'inscription.dart';

class Consultation extends StatefulWidget {
  final ReponseAccueilItem tache;
  const Consultation({super.key, required this.tache});

  final String title = "Consultation";

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  int _selectedIndex = 0;

  late ReponseAccueilItem detailTache;

  @override
  void initState() {
    super.initState();
    detailTache = widget.tache;
    requeteChargerDetail();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double calculerPourcentageTempsRestant() {
    final maintenant = DateTime.now();
    final fin = detailTache.dateLimite;

    if (maintenant.isAfter(fin)) return 100;

    final dureeTotale = fin.difference(maintenant).inSeconds;
    final dureeEcoulee = DateTime.now().difference(maintenant).inSeconds;

    if (dureeTotale <= 0) return 100;

    return (dureeEcoulee / dureeTotale) * 100;
  }

  Future<void> requeteChargerDetail() async {
    try {
      var reponse = await SingletonDio.getDio().get(
        "http://10.0.2.2:8080/tache/detail/${widget.tache.id}",
      );
      setState(() {
        detailTache = ReponseAccueilItem.fromJson(reponse.data);
      });
    } catch (e) {
      print("Erreur chargement détail: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de chargement du détail")),
      );
    }
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
            const SizedBox(height: 100),
            Container(
              width: double.infinity,
              height: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailTache.nom,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),

                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Avancement :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${detailTache.pourcentageAvancement}%",
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Deadline :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          detailTache.dateLimite.toString().split(' ')[0],
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Pourcentage de temps écoulé :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "${calculerPourcentageTempsRestant().toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Changer progression : ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Slider(
                          value: detailTache.pourcentageAvancement.toDouble(),
                          onChanged: (newValue) {
                            setState(() {
                              detailTache = ReponseAccueilItem(
                                id: detailTache.id,
                                nom: detailTache.nom,
                                pourcentageAvancement: newValue.round(),
                                pourcentageTemps: detailTache.pourcentageTemps,
                                dateLimite: detailTache.dateLimite,
                              );
                            });
                          },
                          divisions: 100,
                          label: "${detailTache.pourcentageAvancement}%",
                          min: 0,
                          max: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(
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
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const HomePage(),
                  ),
                );
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
    );
  }
}
