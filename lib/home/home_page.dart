import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final databaseReference = FirebaseDatabase.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

DatabaseReference ref = FirebaseDatabase.instance.ref();

final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var uid = auth.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("WhatsApp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton.icon(
                onPressed: signOut,
                label: const Text('Signing Out'),
                icon: const Icon(Icons.logout_outlined),
              ),
            
      ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                           borderSide:  const BorderSide(color: Colors.grey)
                        ),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        ),
                        hintText: "Search",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                StreamBuilder(
                  stream: firestore.collection('users').snapshots(),
                  builder: (context, snapshot) { 
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6, 
                        itemBuilder: (BuildContext context, int index) { 
                          return const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text("UserName"),
                                          //SizedBox(height: 5,),
                                          Text("Last Message"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text("Timestamp", style: TextStyle(color: Colors.grey),)
                                ],
                              ),
                              SizedBox(height: 20,)
                            ],
                          );
                         },
                      );
                    } 
                
                )
              ],
            ),
          ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}