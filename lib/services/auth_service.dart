import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/login/login_screen.dart';

class AuthService {
   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // New User
  Future<User?> register(String email, String password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference<Object?> usersCollection = firestore.collection(
          'users');

      DocumentReference<Object?> userDoc = usersCollection.doc(
          userCredential.user?.uid);
      userDoc.set({
        'email': userCredential.user!.email.toString(),
        'uid': userCredential.user!.uid,
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }

  // Login User
  Future<User?> login(String email, String password,
      BuildContext context) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      CollectionReference<Object?> usersCollection = firestore.collection(
          'users');

      DocumentReference<Object?> userDoc = usersCollection.doc(
          userCredential.user?.uid);
      userDoc.set({
        'email': userCredential.user?.email.toString(),
        'uid': userCredential.user?.uid,
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }


    // Signing Out User
    Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

   // Delete User 
   Future deleteUser(BuildContext context) async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      debugPrint('$e');

      if (e.code == "requires-recent-login") {
        await _reAuthenticateAndDelete();
      } else {
      }
    } catch (e) {
      debugPrint('$e');
    }
    var uid = firebaseAuth.currentUser?.uid;
    var docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await firebaseAuth.currentUser?.delete();
     await docRef.delete();
    if(context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), (
          route) => false);
    }
  }

  Future<void> _reAuthenticateAndDelete() async {
    try {
      final providerData = firebaseAuth.currentUser?.providerData.first;

      if (GoogleAuthProvider().providerId == providerData?.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }
      else if (EmailAuthProvider.PROVIDER_ID == providerData?.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(EmailAuthProvider as OAuthProvider);
      }

      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }
  
  Future del(BuildContext context) async {
    try {
      await firestore.collection('users').doc(
          FirebaseAuth.instance.currentUser!.uid).delete();
      if(context.mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => LoginScreen()), (
                route) => false);
      }
      await FirebaseAuth.instance.currentUser!.unlink(
          EmailAuthProvider.PROVIDER_ID);
      await FirebaseAuth.instance.currentUser!.unlink(
          GoogleAuthProvider.PROVIDER_ID);
    } catch (e) {
      debugPrint('$e');

    }
  }

}