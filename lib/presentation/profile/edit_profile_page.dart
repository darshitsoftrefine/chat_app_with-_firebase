
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

 String name = "";
 String city = "";
 String phone = "";
 String uid = "";

DatabaseReference database = FirebaseDatabase.instance.ref();

 TextEditingController nameController = TextEditingController();

  TextEditingController cityController = TextEditingController();


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
    getPhoneNumber().then((getPhone){
      setState(() {
        phone = getPhone!;
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
    final users = database.child('users/');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(10.0), 
      child: Column(
        children: [
          const Text("Please enter your name"),
          inputDetails(nameController, name),
          const SizedBox(height: 10,),
          const Text("Please enter your city"),
          inputDetails(cityController, city),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setString('Name', nameController.text.toString() == "" ? name : nameController.text.toString());
                      preferences.setString("City", cityController.text.toString() == "" ? city : cityController.text.toString());
                      
                       await valueExists() ?  const CircularProgressIndicator() : users.child("$uid").update({
                          'name': nameController.text.toString() == "" ? name : nameController.text.toString(),
                          // 'uid': value.user?.uid,
                          // 'photo': value.user?.photoURL,
                          'city': cityController.text.toString() == "" ? city : cityController.text.toString(),
                          'phone': phone,
                          });
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  BottomBar()),);
          }, child: const Text("Edit Profile Details"))
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
      ),
    );
  }

  Future<bool> valueExists() async {
bool val = false;
// Reference to the inside node you want to check
DatabaseReference insideNodeRef = database.child('users/').child('users/$uid');
insideNodeRef.once().then((DatabaseEvent snapshot) {
// The inside node has a value
debugPrint('Value exists outside the root node.');
val = true;
});
return val;
}

  Future<String?> getName() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? name = sharedPreferences.getString('Name');
    debugPrint("Token $name");
    return name;
  }

  Future<String?> getCity() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? city = sharedPreferences.getString('City');
    debugPrint("Token $city");
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
    String? obtainedUid = sharedPreferences.getString('uid');
    debugPrint("Phone Number $obtainedUid");
    return obtainedUid;
  }
}