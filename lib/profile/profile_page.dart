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
      body: const SafeArea(child: Padding(padding: EdgeInsets.all(10.0), 
      child: Column(
        children: [

        ],
      ),
      )),
    );
  }
}