import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/accueuil.dart';
import 'package:intl/intl.dart';

import 'class/transfert.dart';
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
    if (isLoadingCreation) return;

    final l10n = S.of(context)!;

    if (_dateLimite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectDeadlineError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_nomTacheController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterTaskNameError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var req = RequeteAjoutTache(_nomTacheController.text, _dateLimite!);

    try {
      setState(() {
        isLoadingCreation = true;
      });

      var reponse = await SingletonDio.getDio().post(
        'http://10.0.2.2:8080/tache/ajout',
        data: req.toJson(),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = S.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.creationError(e.toString())),
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
    final l10n = S.of(context)!;

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