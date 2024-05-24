import 'package:chat_app/home/home_page.dart';
import 'package:chat_app/login/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginWithOtp extends StatefulWidget {
   const LoginWithOtp({super.key});
   static String verify = "";

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  TextEditingController phoneNumber = TextEditingController(); 

  String phoneNum = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                    await auth.verifyPhoneNumber(
              phoneNumber: phoneNum,
              verificationCompleted: (PhoneAuthCredential credential) async {
                await auth.signInWithCredential(credential);
              }, 
              verificationFailed:  (FirebaseAuthException e) {
                if (e.code == 'invalid-phone-number') {
                  debugPrint('The provided phone number is not valid.');
                }
              },
              codeSent: (String verificationId, int? forceResendingToken) async{
                LoginWithOtp.verify = verificationId; 
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OtpScreen()),
              );
               }, 
              codeAutoRetrievalTimeout: (String verificationId) { 
                 const Duration(seconds: 60);
               },
                        );
                  }, child: const Text("Print")),
                  const SizedBox(height: 20,),
                  const Text("Or"),
                  const SizedBox(height: 20,),
                   ValueListenableBuilder(valueListenable: isLoadingGoogle, builder: (context, loading, child){
                        return loading ? const Center(child: CircularProgressIndicator(),):Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async{
                                isLoadingGoogle.value = !isLoadingGoogle.value;
                                Future.delayed(const Duration(seconds: 2), () {
                                  isLoadingGoogle.value = !isLoadingGoogle.value;
                                });
                                await signInWithGoogle();
                                if(FirebaseAuth.instance.currentUser != null) {
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) =>
                                            const HomePage()), (route) => false);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    )
                                ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/googl.png", width: 30, height: 30,),
                                  const SizedBox(width: 10),
                                  const Text("Sign In With Google", style: TextStyle(color: Colors.black),),
                                ],
                                ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth = await googleUser
            .authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        CollectionReference<Object?> usersCollection = firestore.collection(
            'users');
        DocumentReference<Object?> userDoc = usersCollection.doc(
            userCredential.user?.uid);
        userDoc.set({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
        });
        return userCredential.user;
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }
}