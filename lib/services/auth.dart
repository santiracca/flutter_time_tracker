import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  AppUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<AppUser> get onAuthStateChanged;
  AppUser currentUser();
  Future<AppUser> signInAnonymously();
  Future<AppUser> signInWithGoogle();
  Future<void> signOut();
  Future<AppUser> signInWithEmailAndPassword(String email, String password);
  Future<AppUser> createUserWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(uid: user.uid);
  }

  @override
  Stream<AppUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  AppUser currentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
          // GoogleAuthProvider.getCredential(
          //     idToken: googleAuth.idToken,
          //     accessToken: googleAuth.accessToken)
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKE',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignin = GoogleSignIn();
    await googleSignin.signOut();
    await _firebaseAuth.signOut();
  }
}
