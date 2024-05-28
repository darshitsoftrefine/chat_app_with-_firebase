import 'dart:async';
import 'package:chat_app/presentation/profile/edit_profile_page.dart';
import 'package:chat_app/presentation/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? loginToken = "";
  @override
  void initState() {
    getName().then((value) {
      setState(() {
        loginToken = value;
      });
    });
    super.initState();
    Timer(
        const Duration(seconds: 2),
            () => loginToken == null ? Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ProfilePage())): Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EditProfilePage())));
  }


  Future<String?> getName() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedToken = sharedPreferences.getString('Name');
    debugPrint("Token $obtainedToken");
    return obtainedToken;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/img1.png", fit: BoxFit.fill, height: double.infinity, width: double.infinity,)),
    );
  }
}