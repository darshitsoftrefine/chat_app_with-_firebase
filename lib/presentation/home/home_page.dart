import 'package:chat_app/presentation/home/chat_page.dart';
import 'package:chat_app/presentation/login/login_with_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final databaseReference = FirebaseDatabase.instance;
FirebaseAuth auth = FirebaseAuth.instance;

final ref1= FirebaseDatabase.instance.ref("users/");

 String name = "";
 String city = "";
 String phone = "";
 String uid = "";

final searchController = TextEditingController();

@override
  void initState() {
    getName().then((value){
      setState(() {
        name = value!;
      });
    });
    getCity().then((getCity){
      setState(() {
        city = getCity!;
      });
    });

    getPhoneNumber().then((getNumber){
      setState(() {
        phone =  getNumber!;
      });
    });
    getUid().then((getUid){
      setState(() {
        uid = getUid!;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton.icon(
                onPressed: signOut,
                label: const Text('Sign Out'),
                icon: const Icon(Icons.logout_outlined),
              ),
            
      ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(padding: const EdgeInsets.all(10.0),
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
                
                //Text(displayText),
                FirebaseAnimatedList(query: ref1, 
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                defaultChild: const CircularProgressIndicator(),
                itemBuilder: (context, snapshot, animation, index){
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: snapshot.child('name').value.toString(),)),);
                        },
                          leading: const CircleAvatar(child: Icon(Icons.person),),
                          title: Text(snapshot.child('name').value.toString(), style: const TextStyle(fontSize: 16),),
                         ),
                       
                       const Divider(color: Colors.grey,)
                      ],
                    ),
                  );
                }
                )
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
    await FirebaseAuth.instance.currentUser?.delete();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginWithOtp()),);
  }
  Future<String?> getName() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? name = sharedPreferences.getString('Name');
    debugPrint("Name $name");
    return name;
  }

  Future<String?> getCity() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? city = sharedPreferences.getString('City');
    debugPrint("City $city");
    return city;
  }

  Future<String?> getPhoneNumber() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedNumber = sharedPreferences.getString('phoneNumber');
    debugPrint("Phone Number $obtainedNumber");
    return obtainedNumber;
  }

   Future<String?> getUid() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedNumber = sharedPreferences.getString('uid');
    debugPrint("UId Number $obtainedNumber");
    return obtainedNumber;
  }

}

// name
// phoneNumber
// city
// ElevatedButton(onPressed: (){
//                  ChatViewModel().loadAllUserList();
//                 }, child: const Text("Show")),