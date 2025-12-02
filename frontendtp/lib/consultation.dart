import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontendtp/class/tache.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import 'accueuil.dart';
import 'creation.dart';
import 'generated/l10n.dart';
import 'inscription.dart';

class Consultation extends StatefulWidget {
  final Tache tache;

  const Consultation({super.key, required this.tache});

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> with WidgetsBindingObserver {
  static const String _tacheCollection = 'tache';

  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isLoadingProgress = false;
  final supabase = Supabase.instance.client;
  late String _taskDocId;
  String _taskName = '';
  DateTime _deadline = DateTime.now();
  int _progressPercentage = 0;
  List<Map<String, dynamic>> _progressHistory = [];
  String? _imagePath;
  bool _isDeleted = false;
  final String bucketName = "supaBucket";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeTaskData();
    WidgetsBinding.instance.addObserver(this);
    _loadTaskDetails();
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
      _loadTaskDetails();
    }
  }

  void _initializeTaskData() {
    _taskDocId = widget.tache.docId;
    _taskName = widget.tache.nomTache;
    _progressPercentage = widget.tache.pourcentageAvancement;
    _deadline = widget.tache.dateLimite;
  }

  double _calculateTimeElapsedPercentage() {
    final now = DateTime.now();

    if (now.isAfter(_deadline)) return 100.0;

    DateTime creationDate = now;
    if (_progressHistory.isNotEmpty) {
      try {
        final firstChange = _progressHistory.first['dateChangement'];
        creationDate = _parseDate(firstChange) ?? now;
      } catch (_) {
        creationDate = now;
      }
    }

    if (now.isBefore(creationDate)) return 0.0;

    final totalDuration = _deadline.difference(creationDate).inSeconds;
    if (totalDuration <= 0) return 100.0;

    final elapsedDuration = now.difference(creationDate).inSeconds;
    return ((elapsedDuration / totalDuration) * 100).clamp(0.0, 100.0);
  }

  DateTime? _parseDate(dynamic date) {
    if (date is DateTime) return date;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  Future<void> _loadTaskDetails() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      final doc = await FirebaseFirestore.instance
          .collection(_tacheCollection)
          .doc(_taskDocId)
          .get();

      if (!doc.exists) {
        throw Exception('Task not found in Firestore (id=$_taskDocId)');
      }

      final data = doc.data()!;

      if (mounted) {
        setState(() {
          _taskName = data['nomTache'] ?? _taskName;
          _deadline = _parseDate(data['dateLimite']) ?? _deadline;
          _progressPercentage = _parseIntValue(data['pourcentageAvancement']);
          _progressHistory = _parseProgressHistory(data['changements']);
          _imagePath = data['imageUrl'];
          _isDeleted = data['deleted'] == true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading task details: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(S.of(context)!.detailLoadError);
      }
    }
  }

  int _parseIntValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  List<Map<String, dynamic>> _parseProgressHistory(dynamic rawChangements) {
    if (rawChangements is! List) return [];

    return rawChangements.map((e) {
      if (e is! Map<String, dynamic>) {
        return {'valeur': 0, 'dateChangement': DateTime.now().toIso8601String()};
      }

      final value = _parseIntValue(e['valeur']);
      final date = _parseDate(e['dateChangement']) ?? DateTime.now();

      return {
        'valeur': value,
        'dateChangement': date.toIso8601String(),
      };
    }).toList();
  }

  Future<void> _updateProgress(int newValue) async {
    if (_isLoadingProgress || !mounted) return;

    try {
      setState(() => _isLoadingProgress = true);

      final now = DateTime.now();
      final change = {
        'valeur': newValue,
        'dateChangement': now.toIso8601String(),
      };

      final docRef = FirebaseFirestore.instance
          .collection(_tacheCollection)
          .doc(_taskDocId);

      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(docRef);

        if (!snapshot.exists) {
          tx.set(docRef, {
            'nomTache': _taskName,
            'dateLimite': _deadline,
            'dateCreation': now,
            'pourcentageAvancement': newValue,
            'pourcentageTemps': 0,
            'changements': [change],
            'userId': FirebaseAuth.instance.currentUser?.uid,
          });
        } else {
          tx.update(docRef, {
            'pourcentageAvancement': newValue,
            'changements': FieldValue.arrayUnion([change]),
          });
        }
      });

      if (mounted) {
        setState(() {
          _progressPercentage = newValue;
          _progressHistory = [..._progressHistory, change];
        });
        _showSuccessSnackBar('Progress saved');
      }
    } catch (e) {
      debugPrint("Error updating progress: $e");
      if (mounted) {
        _showErrorSnackBar('${S.of(context)!.updateError}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingProgress = false);
      }
    }
  }

  Future<void> _selectAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    File file = File(image.path);
    String fileName = image.name;


    try{
      final String fullPath = await supabase
          .storage
          .from(bucketName)
          .upload(fileName, file);
      String url = supabase
          .storage
          .from(bucketName)
          .getPublicUrl(fileName);
      FirebaseFirestore.instance.collection('tache').doc(_taskDocId).update({
        'imageUrl': url,
      });
      setState(() {
        _imagePath = url;
      });
      _showSuccessSnackBar("Image mise à jour !");
    }
    catch(e){
      debugPrint("Error uploading image: $e");
      _showErrorSnackBar("Erreur lors de l'upload de l'image : $e");
      return;
    }
    }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _navigateToHome() {
    _onItemTapped(0);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _navigateToCreation() {
    _onItemTapped(1);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const creation()),
    );
  }

  void _navigateToLogout() {
    _onItemTapped(2);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  Future<void> _showDeleteOptions() async {
    final choice = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: _isDeleted
            ? const Text('Tâche supprimée. Vous pouvez la restaurer ou la supprimer définitivement.')
            : const Text('Choisissez suppression douce (soft) ou définitive (hard).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('cancel'),
            child: const Text('Annuler'),
          ),
          if (_isDeleted)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('restore'),
              child: const Text('Restaurer', style: TextStyle(color: Colors.green)),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('soft'),
            child: const Text('Soft delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('hard'),
            child: const Text('Hard delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (choice == 'soft') {
      await softDeleteTask();
    } else if (choice == 'hard') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Suppression définitive : êtes-vous sûr ? Cette action est irréversible.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
          ],
        ),
      );
      if (confirm == true) await hardDeleteTask();
    } else if (choice == 'restore') {
      await _restoreTask();
    }
  }

  Future<void> _restoreTask() async {
    try {
      final docRef = FirebaseFirestore.instance.collection(_tacheCollection).doc(_taskDocId);
      final now = DateTime.now();
      await docRef.update({
        'deleted': false,
        'deletedAt': FieldValue.delete(),
        'deletedBy': FieldValue.delete(),
        'dateModification': now,
      });
      if (mounted) {
        setState(() {
          _isDeleted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche restaurée')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur restauration : $e')));
      }
    }
  }

  Future<void> softDeleteTask() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('tache').doc(_taskDocId);
      final now = DateTime.now();
      await docRef.update({
        'deleted': true,
        'deletedAt': now.toIso8601String(),
        'deletedBy': FirebaseAuth.instance.currentUser?.uid,
        'dateModification': now,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche marquée comme supprimée')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur suppression : $e')));
      }
    }
  }

  Future<void> hardDeleteTask() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('tache').doc(_taskDocId);
      await docRef.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche supprimée définitivement')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur suppression : $e')));
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
        title: Text(l10n.consultationTitle),
        actions: [
          IconButton(
            tooltip: 'Restaurer la tâche',
            icon: const Icon(Icons.restore_from_trash),
            onPressed: !_isDeleted
                ? null
                : () async {
                    await _restoreTask();
                  },
          ),
          IconButton(
            tooltip: 'Supprimer la tâche',
            icon: const Icon(Icons.delete_outline),
            onPressed: _isLoading
                ? null
                : () async {
              await _showDeleteOptions();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTaskDetailsBody(l10n),
      drawer: _buildDrawer(l10n),
    );
  }

  // Build main task details body
  Widget _buildTaskDetailsBody(S l10n) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildContainerDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskTitle(),
                    const SizedBox(height: 50),
                    _buildProgressRow(l10n),
                    const SizedBox(height: 20),
                    _buildDeadlineRow(l10n),
                    const SizedBox(height: 20),
                    _buildTimeElapsedRow(l10n),
                    const SizedBox(height: 20),
                    _buildProgressSlider(l10n),
                    const SizedBox(height: 20),
                    _buildImageUploadButton(l10n),
                    const SizedBox(height: 20),
                    _buildTaskImage(l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Container decoration
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
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
    );
  }

  // Task title widget
  Widget _buildTaskTitle() {
    return Text(
      _taskName,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Progress row
  Widget _buildProgressRow(S l10n) {
    return _buildInfoRow(
      label: l10n.progress,
      value: "$_progressPercentage%",
    );
  }

  // Deadline row
  Widget _buildDeadlineRow(S l10n) {
    return _buildInfoRow(
      label: l10n.deadline,
      value: _deadline.toString().split(' ')[0],
    );
  }

  // Time elapsed row
  Widget _buildTimeElapsedRow(S l10n) {
    return _buildInfoRow(
      label: l10n.timeElapsedPercentage,
      value: "${_calculateTimeElapsedPercentage().toStringAsFixed(1)}%",
    );
  }

  // Generic info row builder
  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
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
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Progress slider
  Widget _buildProgressSlider(S l10n) {
    return Row(
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
            value: _progressPercentage.toDouble(),
            onChanged: _isLoadingProgress
                ? null
                : (newValue) {
              setState(() {
                _progressPercentage = newValue.round();
              });
            },
            onChangeEnd: _isLoadingProgress
                ? null
                : (newValue) => _updateProgress(_progressPercentage),
            divisions: 100,
            label: "$_progressPercentage%",
            min: 0,
            max: 100,
          ),
        ),
      ],
    );
  }

  // Image upload button
  Widget _buildImageUploadButton(S l10n) {
    return Row(
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
            onPressed: _selectAndUploadImage,
            child: Text(l10n.chooseImage),
          ),
        ),
      ],
    );
  }

  // Task image display
  Widget _buildTaskImage(S l10n) {
    return Column(
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
        _buildImageContent(l10n),
      ],
    );
  }

  // Image content
  Widget _buildImageContent(S l10n) {
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: _imagePath!,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildImageError(l10n),
        ),
      );
    }

    return _buildNoImage(l10n);
  }

  // Image placeholder
  Widget _buildImagePlaceholder() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // Image error widget
  Widget _buildImageError(S l10n) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 80),
            const SizedBox(height: 10),
            Text(
              l10n.loadingError,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // No image widget
  Widget _buildNoImage(S l10n) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_not_supported, color: Colors.white70, size: 80),
            const SizedBox(height: 10),
            Text(
              l10n.noImage,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Build drawer menu
  Widget _buildDrawer(S l10n) {
    return Drawer(
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
            onTap: _navigateToHome,
          ),
          ListTile(
            title: Text(l10n.taskCreation),
            selected: _selectedIndex == 1,
            onTap: _navigateToCreation,
          ),
          ListTile(
            title: Text(l10n.logout),
            selected: _selectedIndex == 2,
            onTap: _navigateToLogout,
          ),
        ],
      ),
    );
  }
}
