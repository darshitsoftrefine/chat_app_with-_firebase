import 'package:flutter/material.dart';

class ViewImageScreen extends StatefulWidget {
  final String message;
  final String userEmail;
  const ViewImageScreen({super.key, required this.message, required this.userEmail});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_rounded), color: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert), color: Colors.white,)
        ],
      ),
      body: Center(child: Image.network(widget.message)),
    );
  }
}
