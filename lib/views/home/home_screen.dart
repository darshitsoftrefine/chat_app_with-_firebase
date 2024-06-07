import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chats/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../video_call/video_call_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        centerTitle: true,
         actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
          }, icon: const Icon(Icons.person))
        ],
        leading: IconButton(onPressed: (){
          AuthService().signOut();
        }, icon: const Icon(Icons.logout),),
      ),

      body: SafeArea(child: Padding(padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(stream: FirebaseFirestore.instance.collection("users").snapshots(), 
            builder: (context, snapshot){
              if(snapshot.hasError){
                return const Center(child: Text("Error in showing data"),);
              } 
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
              );
            })
          ],
        ),
      ),
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallScreen()));
      },child: const Icon(Icons.video_call),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      if(FirebaseAuth.instance.currentUser!.email != data['email']) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(data['email']),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverUserEmail: data['email'], receiverUserId: data['uid'],)));
          },
        );
      } else {
        return Container();
      }
  }
}