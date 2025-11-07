import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/class/reponseAccueilItem.dart';
import 'package:frontendtp/class/reponseDetailTache.dart';
import 'package:image_picker/image_picker.dart';

import 'accueuil.dart';
import 'class/reponseDetailTacheAvecPhoto.dart';
import 'creation.dart';
import 'generated/l10n.dart';
import 'inscription.dart';

class Consultation extends StatefulWidget {
  final ReponseAccueilItem tache;

  const Consultation({super.key, required this.tache});

  final String title = "Consultation";

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> with WidgetsBindingObserver{
  int _selectedIndex = 0;
  final ImagePicker picker = ImagePicker();
  late ReponseDetailTache detailTache;
  String? imagePath;
  bool isLoading = true;
  bool isLoadingProgress = false;

  @override
  void initState() {
    super.initState();
    print("Loading detail for task ID: ${widget.tache.id}");
    detailTache = ReponseDetailTache(
      id: 0,
      nom: '',
      pourcentageAvancement: 0,
      pourcentageTemps: 0,
      dateLimite: DateTime.now(),
      changements: [],
    );
    WidgetsBinding.instance.addObserver(this);
    chargerDetailTache();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      chargerDetailTache();
    }
  }

  double calculerPourcentageTempsRestant() {
    final maintenant = DateTime.now();
    final fin = detailTache.dateLimite;

    if (maintenant.isAfter(fin)) return 100;

    final dureeTotale = fin.difference(maintenant).inSeconds;

    if (dureeTotale <= 0) return 100;

    return ((1 - (dureeTotale / dureeTotale)) * 100).clamp(0, 100);
  }

  Future<void> mettreAJourAvancement(int idTache, int valeur) async {
    if (isLoadingProgress) return;

    try {
      setState(() {
        isLoadingProgress = true;
      });
      final response = await SingletonDio.getDio().get(
        "http://10.0.2.2:8080/tache/progres/$idTache/$valeur",
      );

      if (response.statusCode == 200) {
        setState(() {
          detailTache = ReponseDetailTache(
            id: detailTache.id,
            nom: detailTache.nom,
            pourcentageAvancement: valeur,
            pourcentageTemps: detailTache.pourcentageTemps,
            dateLimite: detailTache.dateLimite,
            changements: detailTache.changements,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = S.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.updateError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingProgress = false;
        });
      }
    }
  }

  Future<void> chargerDetailTache() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (widget.tache.id <= 0) {
        throw Exception("ID de tâche invalide");
      }
      Response response = await SingletonDio.getDio().get(
        "http://10.0.2.2:8080/api/detail/photo/${widget.tache.id}",
      );

      if (response.statusCode == 200) {
        print("Réponse serveur: ${response.data}");
        final detail = ReponseDetailTacheAvecPhoto.fromJson(response.data);
        print("Photo ID reçu: ${detail.photoId}");

        if (mounted) {
          setState(() {
            detailTache = ReponseDetailTache(
              id: detail.id,
              nom: detail.nom,
              pourcentageAvancement: detail.pourcentageAvancement,
              pourcentageTemps: detail.pourcentageTemps,
              dateLimite: detail.dateLimite,
              changements: detail.changements,
            );

            if (detail.photoId != null) {
              imagePath =
              "http://10.0.2.2:8080/fichier/${detail.photoId}?largeur=1080";
            } else {
              imagePath = null;
              print("Pas de photo pour cette tâche");
            }
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Erreur lors du chargement du détail de la tâche : $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        final l10n = S.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.detailLoadError)),
        );
      }
    }
  }

  Future<void> selectionnerImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    try {
      String filename = image.name;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: filename),
        "taskID": detailTache.id.toString(),
      });
      Response response = await SingletonDio.getDio().post(
        "http://10.0.2.2:8080/fichier",
        data: formData,
      );

      if (response.statusCode == 200) {
        String id = response.data.toString();
        String imageUrl = "http://10.0.2.2:8080/fichier/$id?largeur=1080";

        setState(() {
          imagePath = imageUrl;
        });
      }
    } catch (e) {
      print("Erreur lors de l'envoi de l'image : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.consultationTitle),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
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
                child: SingleChildScrollView(
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
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.progress,
                              style: const TextStyle(
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
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.deadline,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              detailTache.dateLimite.toString().split(
                                ' ',
                              )[0],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.timeElapsedPercentage,
                              style: const TextStyle(
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
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.changeProgress,
                              style: const TextStyle(
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
                              onChanged: isLoadingProgress
                                  ? null
                                  : (newValue) {
                                final nouveauPourcentage = newValue.round();
                                setState(() {
                                  detailTache = ReponseDetailTache(
                                    id: detailTache.id,
                                    nom: detailTache.nom,
                                    pourcentageAvancement:
                                    nouveauPourcentage,
                                    pourcentageTemps: detailTache
                                        .pourcentageTemps,
                                    dateLimite:
                                    detailTache.dateLimite,
                                    changements:
                                    detailTache.changements,
                                  );
                                });
                              },
                              onChangeEnd:  isLoadingProgress
                                  ? null
                                  : (newValue) async {
                                await mettreAJourAvancement(
                                  detailTache.id,
                                  detailTache.pourcentageAvancement,
                                );
                              },
                              divisions: 100,
                              label:
                              "${detailTache.pourcentageAvancement}%",
                              min: 0,
                              max: 100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.addImage,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () => selectionnerImage(),
                              child: Text(l10n.chooseImage),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.taskImage,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isLoading)
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (imagePath != null &&
                              imagePath!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: imagePath!,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  return Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.white70,
                                            size: 80,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            l10n.loadingError,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white70,
                                      size: 80,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.noImage,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                l10n.menu,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.home),
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
              title: Text(l10n.taskCreation),
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
              title: Text(l10n.logout),
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