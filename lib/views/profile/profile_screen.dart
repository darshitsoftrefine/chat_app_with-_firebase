import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Name'),
            const SizedBox(height: 10,),
            Text(_auth.currentUser!.displayName.toString()),
            const Text("Email"),
            const SizedBox(height: 10,),
            Text(_auth.currentUser!.email.toString())
          ],
        ),
      )),
    );
  }
}