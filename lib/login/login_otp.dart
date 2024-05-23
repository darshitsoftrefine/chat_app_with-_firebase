import 'package:chat_app/login/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginWithOtp extends StatefulWidget {
   LoginWithOtp({super.key});
   static String verify = "";

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  TextEditingController phoneNumber = TextEditingController(); 

  String phoneNum = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp", style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/img1.png')),
              const SizedBox(height: 20,),
              const Text("Login"),
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
                await auth.verifyPhoneNumber(
  phoneNumber: phoneNum,
  verificationCompleted: (PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
  }, 
  verificationFailed:  (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
  },
  codeSent: (String verificationId, int? forceResendingToken) {
    LoginWithOtp.verify = verificationId; 
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OtpScreen()),
  );
   }, 
  codeAutoRetrievalTimeout: (String verificationId) {  },
);
              }, child: Text("Print"))
            ],
          ),
        ),
      ),
    );
  }
}