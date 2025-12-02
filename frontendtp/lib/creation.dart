import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:intl/intl.dart';

import 'generated/l10n.dart';
import 'inscription.dart';

class creation extends StatefulWidget {
  const creation({super.key});

  @override
  State<creation> createState() => _creationState();
}

class _creationState extends State<creation> {
  int _selectedIndex = 0;
  final TextEditingController _nomTacheController = TextEditingController();
  DateTime? _dateLimite;
  bool isLoadingCreation = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    initFirebase();
  }
  void initFirebase() async{
    await Firebase.initializeApp();
  }
  @override
  void dispose() {
    _nomTacheController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dateLimite = picked;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> creerTache() async {
    String? imageUrl;
    if (isLoadingCreation) return;

    final l10n = S.of(context);

    if (_dateLimite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectDeadlineError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_nomTacheController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterTaskNameError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoadingCreation = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        final String msg = 'Utilisateur non connecté. Veuillez vous reconnecter.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      DateTime now = DateTime.now();
      int pourcentageTempsCalculated;
      if (_dateLimite == null) {
        pourcentageTempsCalculated = 0;
      } else if (_dateLimite!.isBefore(now)) {
        pourcentageTempsCalculated = 100;
      } else {
        pourcentageTempsCalculated = 0;
      }
      int pourcentageAvancementCalculated = 0;

      final Map<String, dynamic> changementInitial = {
        'valeur': pourcentageAvancementCalculated,
        'dateChangement': now.toIso8601String(),
      };

      CollectionReference tacheCollection = FirebaseFirestore.instance.collection('tache');
      await tacheCollection.add({
        'nomTache': _nomTacheController.text.trim(),
        'dateLimite': _dateLimite,
        'dateCreation': now,
        'pourcentageAvancement': pourcentageAvancementCalculated,
        'pourcentageTemps': pourcentageTempsCalculated,
        'changements': [changementInitial],
        'userId': currentUser.uid,
        'imageUrl': imageUrl,
      });

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        String friendlyMessage;
        if (e is FirebaseException) {
          switch (e.code) {
            case 'permission-denied':
              friendlyMessage = 'Accès refusé : vous n\'avez pas la permission de créer une tâche.';
              break;
            case 'unavailable':
              friendlyMessage = 'Service temporairement indisponible. Vérifiez votre connexion et réessayez.';
              break;
            case 'deadline-exceeded':
              friendlyMessage = 'La requête a expiré. Réessayez plus tard.';
              break;
            default:
              friendlyMessage = e.message ?? 'Erreur Firebase (${e.code}).';
          }
        } else if (e is Exception) {
          friendlyMessage = 'Erreur lors de la création : ${e.toString()}';
        } else {
          friendlyMessage = 'Erreur inconnue lors de la création.';
        }
        print('creerTache error: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCreation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.creationTitle),
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
                Navigator.of(context).pop(true);
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _nomTacheController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: l10n.taskNameLabel,
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _dateLimite == null
                          ? l10n.chooseDeadline
                          : l10n.deadlineSelected(DateFormat('yyyy-MM-dd').format(_dateLimite!)),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: isLoadingCreation ? null : creerTache,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: isLoadingCreation
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeWidth: 2,
                  ),
                )
                    : Text(l10n.addTask),
              ),
            ],
          ),
        ),
      ),
    );
  }
}