import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

    } on FirebaseAuthException catch (e) {
      String message = "";

      switch (e.code) {
        case 'weak-password':
          message = "Le mot de passe est trop faible. Utilisez au moins 6 caractères.";
          break;
        case 'email-already-in-use':
          message = "Un compte existe déjà avec cette adresse email.";
          break;
        case 'invalid-email':
          message = "L'adresse email n'est pas valide.";
          break;
        case 'operation-not-allowed':
          message = "L'inscription par email/mot de passe n'est pas activée.";
          break;
        case 'network-request-failed':
          message = "Erreur de connexion. Vérifiez votre connexion internet.";
          break;
        default:
          message = "Erreur d'inscription: ${e.message ?? e.code}";
      }

      print("Erreur Firebase Auth: $message");
      throw Exception(message);

    } catch (e) {
      print("Erreur inattendue lors de l'inscription: $e");
      throw Exception("Une erreur inattendue s'est produite. Veuillez réessayer.");
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch(e){
      String message = "";
      if(e.code == 'weak-password'){
        message = "The password provided is too weak.";
      } else if(e.code == 'email-already-in-use'){
        message = "The account already exists for that email.";
      }
      print(message);
    }
    catch(e){
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
    }
    on FirebaseAuthException catch(e){
      print(e);
    }
  }
}