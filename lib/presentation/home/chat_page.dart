import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String name;
  const ChatPage({super.key, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController messageController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final messages = ref.child("users/");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //StreamBuilder(stream: , builder: builder)
              Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 8, top: 8, left: 16),
                                  hintText: "Type Here..",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              //send messages
                              await messages.update({
                                'message': messageController.text.toString()
                              });
                              },
                            backgroundColor: Colors.purple[100],
                            child: const Icon(Icons.send),
                          )
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }
}