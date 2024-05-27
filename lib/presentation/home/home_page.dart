import 'package:chat_app/chat_view.dart';
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
FirebaseAuth auth = FirebaseAuth.instance;

DatabaseReference ref = FirebaseDatabase.instance.ref();

 String displayText = 'Welcome';


final searchController = TextEditingController();

@override
  void initState() {
    super.initState();
    _activateListeners();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                ElevatedButton(onPressed: (){
                 ChatViewModel().loadAllUserList();
                }, child: const Text("Show")),
                Text(displayText),
                // StreamBuilder(stream: ref.child('users/').onValue, 
                // builder: (context, snapshot){
                //   if(snapshot.hasData){
                //     final dailyUsers = UserModel.fromRTDB(Map<String, dynamic>.from(
                //       (snapshot.data! as Event).snapshot.value
                //     ));
                    
                //   }
                // })
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

    void _activateListeners() {
    ref.child("users/").onValue.listen((event) {
      final String msg = event.snapshot.value.toString();
      setState(() {
        displayText = msg;
      });
    });
  }
}

// name
// phoneNumber
// city