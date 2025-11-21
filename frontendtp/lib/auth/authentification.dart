import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final GoogleSignInClientAuthorization? authorizationClient =
    await googleUser.authorizationClient.authorizationForScopes(['email']);

    final credential = GoogleAuthProvider.credential(
      accessToken: authorizationClient!.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}