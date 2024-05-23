import 'package:chat_app/login/login_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../home/home_page.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter Otp"),
            SizedBox(height: 20,),
            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true, 
              onCodeChanged: (value){
                code = value;
              },
            ),
            ElevatedButton(onPressed: ()async{
              try{
                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: LoginWithOtp.verify, smsCode: code);
        
              await auth.signInWithCredential(credential);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  const HomePage()),);
              } catch(e){
                showDialog(context: context, 
                builder: (BuildContext context) { 
                  print(e);
                  return  AlertDialog(
                    title: Text("Wrong Otp"),
                    actions: [
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text("Go back"))
                    ],
                  );
                 },
                );
              }
              
            }, child: const Text("Verify"))
          ],
        ),
      ),
      )
      ),
    );
  }
}