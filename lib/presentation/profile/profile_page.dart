import 'package:chat_app/utils/bottom_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseReference database = FirebaseDatabase.instance.ref();
   bool validate = false;

  TextEditingController nameController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  String phone = "";

  void initState(){
    getPhoneNumber().then((getNumber){
      setState(() {
        phone = getNumber!;
      });
    });
    super.initState();
  }

   Future<String?> getPhoneNumber() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedNumber = sharedPreferences.getString('phoneNumber');
    debugPrint("Phone Number $obtainedNumber");
    return obtainedNumber;
  }

  @override
  Widget build(BuildContext context) {
    final users = database.child('users/');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(10.0), 
      child: Column(
        children: [
          const Text("Please enter your name"),
          inputDetails(nameController, "Name"),
          const SizedBox(height: 10,),
          const Text("Please enter your city"),
          inputDetails(cityController, "City"),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: () async {
            setState(() {
              validate = nameController.text.isEmpty;
            });
             final nextUser = <String, dynamic> {
              'name': nameController.text.toString(),
              'city': cityController.text.toString(),
              'phone': phone,
              
            };
            users.push().set(nextUser).then((value) => print("User is added"));
            SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setString('Name', nameController.text.toString());
                      preferences.setString("City", cityController.text.toString());

                      //  await users.update({
                      //     'name': nameController.text.toString(),
                      //     // 'uid': value.user?.uid,
                      //     // 'photo': value.user?.photoURL,
                      //     'city': cityController.text.toString(),
                      //     'phone': phone,
                      //     });
                      validate ? Container() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomBar()),);
          }, child: const Text("Add Profile Details"))
        ],
      ),
      )),
    );
  }

  TextField inputDetails(TextEditingController name, String label) {
    return TextField(
            controller: name,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),),
        hintText: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.0,),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.0,),
        ),
        errorText: validate ? "Value Can't Be Empty" : null,
      ),
    );
  }
}