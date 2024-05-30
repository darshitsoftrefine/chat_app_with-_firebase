import 'package:chat_app/views/home/home_screen.dart';
import 'package:chat_app/views/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

   final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/img1.png", width: 200, height: 200,),
              const SizedBox(height: 10,),
              const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              inputDetails(emailController, "E-Mail"),
              const SizedBox(height: 20,),
              inputDetails(passwordController, "Password"),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen()),);
                },
                child: const Text("Not a user? Please Sign In", style: TextStyle(fontSize: 16),)),
                const SizedBox(height: 20,),
              ValueListenableBuilder(valueListenable: isLoading, builder: (context, loading, child){
                          return loading? const Center(child: CircularProgressIndicator()): Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: () async{
                                  if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Email / Password"), backgroundColor: Colors.red,));
                                  } else {
                                    isLoading.value = !isLoading.value;
                                      Future.delayed(const Duration(seconds: 2), () {
                                      isLoading.value = !isLoading.value;
                                      });
                                    await AuthService().login(emailController.text, passwordController.text, context);
                                    if(FirebaseAuth.instance.currentUser != null){
                                      if(context.mounted) {
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) => const HomeScreen()), (
                                                route) => false);
                                      }
                                    }
                                  }
                                },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      fixedSize: const Size(367, 48)
                                  ),
                                  child: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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