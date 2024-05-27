import 'package:chat_app/presentation/login/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithOtp extends StatefulWidget {
   const LoginWithOtp({super.key});

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  TextEditingController phoneNumber = TextEditingController(); 

  String phoneNum = "";

  FirebaseAuth auth = FirebaseAuth.instance;

   final database = FirebaseDatabase.instance.ref();

  final ValueNotifier<bool> isLoadingGoogle = ValueNotifier<bool>(false);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("WhatsApp", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/img1.png')),
                  const SizedBox(height: 20,),
                  const Text("Login", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                   IntlPhoneField(
                    controller: phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone){
                        phoneNum = phone.completeNumber;
                      }, // Set the initial country code
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      
                    await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNum,
              verificationCompleted: (PhoneAuthCredential credential) {
               
              }, 
              verificationFailed:  (FirebaseAuthException e) {
               
              },
              codeSent: (String verificationId, int? forceResendingToken) async{
    
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId,)),
              );
               }, 
              codeAutoRetrievalTimeout: (String verificationId) { 
                
               },
                        );
                  }, child: const Text("Send OTP")),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}