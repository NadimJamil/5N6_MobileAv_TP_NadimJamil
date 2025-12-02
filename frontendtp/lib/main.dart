import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontendtp/inscription.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'notification/notification_service.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GlobalKey<ScaffoldMessengerState> snackbarKey =
GlobalKey<ScaffoldMessengerState>();

const supabaseUrl = 'https://bcwqqjtlrcflpkndgvmx.supabase.co';
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjd3FxanRscmNmbHBrbmRndm14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3MDEyODMsImV4cCI6MjA4MDI3NzI4M30.M7gwC6JUmpUkUFF7oTi0BUpWv_MpBZmsxee0BKvhLic";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      _trySignOut();
    }
  }

  Future<void> _trySignOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        debugPrint('Utilisateur déconnecté via lifecycle');
      } catch (e) {
        debugPrint('Erreur signOut: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      onGenerateTitle: (context) => S.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignUpPage(),
    );
  }
}