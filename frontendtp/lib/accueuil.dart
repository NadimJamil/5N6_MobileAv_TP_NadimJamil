import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/class/reponseAccueilItemAvecPhoto.dart';
import 'package:frontendtp/classExterne/designCarteListe.dart';
import 'package:frontendtp/consultation.dart';
import 'package:frontendtp/creation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'generated/l10n.dart';
import 'inscription.dart';

class HomePage extends StatefulWidget {
  final int? photoId;
  const HomePage({super.key, this.photoId});

  final String title = "Connection";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  List<ReponseAccueilItemAvecPhoto> itemsAvecPhoto = [];
  bool isLoadingAccueil = false;
  bool isLoadingDeconnexion = false;
  StreamSubscription<QuerySnapshot>? _tacheSubscription;
  String? _token;
  bool _isLoading = false;
  String _message = "Aucune action effectuée";
  String apiUrl = "http://10.0.2.2:8080";


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chargerAccueilAvecPhoto();
    recupToken();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tacheSubscription?.cancel();
    super.dispose();
  }

  Future<void> recupToken() async {
    setState(() {
      _isLoading = true;
      _message = "Récupération du token...";
    });

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        setState(() {
          _token = token;
          print("Jeton enregistré : $token");
        });
      } else {
        setState(() {
          _message = "Erreur : Token null";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Erreur lors de l'enregistrement : $e";
      });
      print("Erreur lors de l'enregistrement du jeton : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> enregistrerJeton(String token) async {
    try {
      final response = await SingletonDio.getDio().post(
        '$apiUrl/enregistrer-jeton-notification',
        data: token,
      );
      if (response.statusCode == 200) {
        setState(() {
          _message = "✅ ${response.data}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "❌ Erreur: $e";
      });
      print("Erreur lors de l'enregistrement du jeton : $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      chargerAccueilAvecPhoto();
    }
  }

  void navCreation() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const creation()));
    chargerAccueilAvecPhoto();
  }

  DateTime _parseDateLimite(dynamic dateLimite) {
    if (dateLimite == null) return DateTime.now();
    if (dateLimite is Timestamp) return dateLimite.toDate();
    if (dateLimite is String) return DateTime.tryParse(dateLimite) ?? DateTime.now();
    return DateTime.now();
  }

  ReponseAccueilItemAvecPhoto? _convertirDocument(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      DateTime dateLimite = _parseDateLimite(data['dateLimite']);

      return ReponseAccueilItemAvecPhoto(
        id: int.tryParse(doc.id) ?? 0,
        nom: data['nomTache'] ?? 'Sans titre',
        pourcentageAvancement: data['pourcentageAvancement'] ?? 0,
        pourcentageTemps: data['pourcentageTemps'] ?? 0,
        dateLimite: dateLimite,
        photoId: data['photoId'],
      );
    } catch (e) {
      print("Erreur conversion document ${doc.id}: $e");
      return null;
    }
  }

  void chargerAccueilAvecPhoto() {
    setState(() => isLoadingAccueil = true);

    _tacheSubscription = FirebaseFirestore.instance
        .collection('tache')
        .where('userId', isEqualTo: user!.uid)
        .snapshots()
        .listen(
          (snapshot) {
        final taches = snapshot.docs
            .map((doc) => _convertirDocument(doc))
            .whereType<ReponseAccueilItemAvecPhoto>()
            .toList();

        setState(() {
          itemsAvecPhoto = taches;
          isLoadingAccueil = false;
        });
      },
      onError: (e) {
        print("Erreur chargement accueil avec photo: $e");
        setState(() => isLoadingAccueil = false);
      },
    );
  }

  Future<void> deconnexion(BuildContext context) async {
    if(isLoadingDeconnexion) return;

    try {
      setState(() {
        isLoadingDeconnexion = true;
      });

      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      SessionUtilisateur().clear();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignUpPage()),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).logout ?? "Déconnexion réussie"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      final l10n = S.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.connectionErrorWithDetails(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally {
      if (mounted) {
        setState(() {
          isLoadingDeconnexion = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.homeTitle),
      ),
      body: isLoadingAccueil
          ? const Center(child: CircularProgressIndicator())
          : itemsAvecPhoto.isEmpty
          ? Center(
        child: Text(
          l10n.noTasksAvailable,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: itemsAvecPhoto.length,
        itemBuilder: (context, index) {
          final item = itemsAvecPhoto[index];
          return CarteListe(
            tache: item,
            photoId: item.photoId,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Consultation(tache: item),
                ),
              );
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                user?.email ?? l10n.user,
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
                Navigator.pop(context);
                // chargerAccueilAvecPhoto();
              },
            ),
            ListTile(
              title: Text(l10n.taskCreation),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
                navCreation();
              },
            ),
            ListTile(
              title: const Text("Test notification"),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final response = await SingletonDio.getDio().post(
                    "$apiUrl/test/notifications",
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notification test envoyée")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : ${response.statusCode}")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur d’envoi : $e")),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(l10n.logout),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                deconnexion(context);
              },
              trailing: isLoadingDeconnexion
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navCreation,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 6,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}