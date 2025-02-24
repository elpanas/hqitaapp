import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider, UserCredential;
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication;
import 'package:hqitaapp/providers/hqplayer_provider.dart';

class FireProvider extends ChangeNotifier {
  FireProvider(this.hqpP);

  final HQPlayerProvider? hqpP;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // coverage:ignore-start
  Future<bool> registerWithEmail(email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        hqpP!.userId = userCredential.user!.uid;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> signInWithEmail(email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        hqpP!.userId = userCredential.user!.uid;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      hqpP!.userId = userCredential.user!.uid;
      return true;
    } else {
      return false;
    }
  }

  /* Future<String> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  if (result.accessToken != null) {
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    if (userCredential.user != null)
      return userCredential.user!.uid;
    else
      return '';
  } else
    return '';
}*/

  Future signOut() async {
    await _auth.signOut();
    hqpP!.userId = '';
  }
  // coverage:ignore-end
}
