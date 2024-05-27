import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});


  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

   Future<String?> getPhoneNumber() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedNumber = sharedPreferences.getString('phoneNumber');
    debugPrint("Phone Number $obtainedNumber");
    return obtainedNumber;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(10.0), 
      child: Column(
        children: [
          Text("Please enter your name"),
          TextField(
            controller: nameController,
          ),
          SizedBox(height: 10,),
          Text("Please enter your city"),
          TextField(
            controller: cityController,
          ),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setString('Name', nameController.text.toString());
                      preferences.setString("City", cityController.text.toString());
          }, child: const Text("Add Profile Details"))
        ],
      ),
      )),
    );
  }
}