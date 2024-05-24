import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReadMessages extends StatefulWidget {
  const ReadMessages({super.key});

  @override
  State<ReadMessages> createState() => _ReadMessagesState();
}

class _ReadMessagesState extends State<ReadMessages> {
  final database = FirebaseDatabase.instance.ref();
  String displayText = 'Welcome';

  late StreamSubscription _dailyMessage;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    database.child("messages/message").onValue.listen((event) {
      final String msg = event.snapshot.value.toString();
      setState(() {
        displayText = msg;
      });
    });
  }
  
  @override
  void dispose() {
    _dailyMessage.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read Messages"),
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(displayText)
          ],
        ),
        ),
      ),
    );
  }
}