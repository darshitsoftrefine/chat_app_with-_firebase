import 'package:chat_app/presentation/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController otpController = TextEditingController();

  final database = FirebaseDatabase.instance.ref();

  

  @override
  Widget build(BuildContext context) {
     final users = database.child('users/');
    return Scaffold(
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Enter Otp"),
            const SizedBox(height: 20,),
            // Pinput(
            //   controller: otpController,
            //   length: 6,
            //   showCursor: true,
            // ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              try{
                PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: otpController.text.toString());
              FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                prefs.setString("uid", value.user!.uid);
               try{
                bool isEmpty = await isDatabaseEmpty(database);
                if(isEmpty){
                  await users.update({'email': value.user?.email,
                          'name': value.user?.displayName,
                          'uid': value.user?.uid,
                          'photo': value.user?.photoURL,
                          'tenantId': value.user?.tenantId,
                          'phone': value.user?.phoneNumber,
                          });
                } else {
                  await users.push().set({'email': value.user?.email,
                          'name': value.user?.displayName,
                          'uid': value.user?.uid,
                          'photo': value.user?.photoURL,
                          'tenantId': value.user?.tenantId,
                          'phone': value.user?.phoneNumber});
                }
         
          } catch(e){
             debugPrint("You got an error $e");
                                                  }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfilePage()),);
              });

              
              } catch(e){
                debugPrint(e.toString());
              }
              
            }, child: const Text("Verify")),
          ],
        ),
      ),
      )
      ),
    );
  }

  Future<bool> isDatabaseEmpty(DatabaseReference databaseReference) async {
    DataSnapshot snapshot = (await databaseReference.once()) as DataSnapshot;
    return snapshot.value == null;
  }

}