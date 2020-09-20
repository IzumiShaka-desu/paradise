import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<User> signInWithGoogle();
  Future<void> signOut();
}

class AuthService implements BaseAuth {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Future<User> signInWithGoogle() async {
    User user ;
    try{
      final GoogleSignInAuthentication _googleAuth =
          await (await _googleSignIn.signIn()).authentication;
      final AuthCredential _credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      user = (await auth.signInWithCredential(_credential)).user;
    }catch(e){
      debugPrint(e.toString());
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
