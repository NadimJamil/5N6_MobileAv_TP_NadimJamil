import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/HTTP/http.dart';
import 'package:frontendtp/class/reponseAccueilItemAvecPhoto.dart';
import 'package:frontendtp/class/reponseConnexion.dart';
import 'package:frontendtp/class/reponseDetailTacheAvecPhoto.dart';
import 'package:frontendtp/classExterne/designCarteListe.dart';
import 'package:frontendtp/consultation.dart';
import 'package:frontendtp/creation.dart';
import 'package:path_provider/path_provider.dart';
import 'class/tache.dart';
import 'class/reponseAccueilItem.dart';
import 'inscription.dart';

class HomePage extends StatefulWidget {
  final int? photoId;
  const HomePage({super.key, this.photoId});

  final String title = "Connection";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  int _selectedIndex = 0;
  List<ReponseAccueilItemAvecPhoto> itemsAvecPhoto = [];
  bool isLoadingAccueil = true;
  bool isLoadingDeconnexion = false;

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {;
      chargerAccueilAvecPhoto();
    }
  }

  void navCreation() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const creation()));
    chargerAccueilAvecPhoto();
  }

  Future<void> chargerAccueilAvecPhoto() async {
    try {
      setState(() => isLoadingAccueil = true);
      Response response = await SingletonDio.getDio().get("http://10.0.2.2:8080/api/accueil/photo");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        itemsAvecPhoto = data.map((e) => ReponseAccueilItemAvecPhoto.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print("Erreur chargement accueil avec photo: $e");
    } finally {
      setState(() => isLoadingAccueil = false);
    }
  }

  Future<void> deconnexion(BuildContext context) async {
    if(isLoadingDeconnexion) return;

    try {
      setState(() {
        isLoadingDeconnexion = true;
      });

      final response = await SingletonDio.getDio().post(
        'http://10.0.2.2:8080/id/deconnexion',
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignUpPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la déconnexion'),
              backgroundColor: Colors.red,
            ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion : $e'),
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(205, 200, 205, 0.6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Accueil"),
      ),
      body: isLoadingAccueil
          ? const Center(child: CircularProgressIndicator())
          : itemsAvecPhoto.isEmpty
          ? const Center(
        child: Text(
          "Aucune tâche disponible",
          style: TextStyle(fontSize: 18, color: Colors.grey),
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
                      builder: (_) => Consultation(tache: item)
                  )
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
                SessionUtilisateur().nomUtilisateur ?? 'Utilisateur',
                style: const TextStyle(
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
                Navigator.pop(context);
                chargerAccueilAvecPhoto();
              },
            ),
            ListTile(
              title: const Text('Création de tâche'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
                navCreation();
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
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
