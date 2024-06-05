import 'package:chat_app/utils/string_constants.dart';
import 'package:chat_app/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

   final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(ConstantStrings.registerText),
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(ConstantStrings.onboardingImage, width: 200, height: 200,),
              const SizedBox(height: 10,),
              const Text(ConstantStrings.pleaseRegisterText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              inputDetails(emailController, ConstantStrings.emailText),
              const SizedBox(height: 20,),
              inputDetails(passwordController, ConstantStrings.passwordText),
              const SizedBox(height: 20,),
              inputDetails(confirmPasswordController, ConstantStrings.confirmPasswordText),
              const SizedBox(height: 20,),
              ValueListenableBuilder(valueListenable: isLoading, builder: (context, loading, child){
                          return loading? const Center(child: CircularProgressIndicator()): Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: () async{
                                  if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ConstantStrings.enterEmailPassword), backgroundColor: Colors.red,));
                                  } else {
                                    isLoading.value = !isLoading.value;
                                      Future.delayed(const Duration(seconds: 2), () {
                                      isLoading.value = !isLoading.value;
                                      });
                                    await AuthService().register(emailController.text, passwordController.text, context);
                                    if(FirebaseAuth.instance.currentUser != null){
                                      if(context.mounted) {
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) => const HomeScreen()), (route) => false);
                                      }
                                    }
                                  }
                                },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      fixedSize: const Size(367, 48)
                                  ),
                                  child: const Text(ConstantStrings.registerText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
}