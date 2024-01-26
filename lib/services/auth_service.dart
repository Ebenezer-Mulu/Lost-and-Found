import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    // Sign out the current Google account
    await GoogleSignIn().signOut();

    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

      if (guser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication gAuth = await guser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await _fireStore.collection('user').doc(guser.id).set({
        'uid': guser.id,
        'email': guser.email,
        'username': guser.email.split('@')[0] //  initial username
      });

      // Sign in with the Google credentials
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }
}
