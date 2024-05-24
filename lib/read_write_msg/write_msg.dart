import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WriteMessages extends StatefulWidget {
  const WriteMessages({super.key});

  @override
  State<WriteMessages> createState() => _WriteMessagesState();
}

class _WriteMessagesState extends State<WriteMessages> {

   final database = FirebaseDatabase.instance.ref();
   final writeMsg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages = database.child('messages/');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Messages"),
      ),
      body: SafeArea(child: Center(
        child: Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ValueListenableBuilder(
                                      valueListenable: writeMsg,
                                      builder: (BuildContext context, value, Widget? child) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: writeMsg,
                                                decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      borderSide:  const BorderSide(color: Colors.grey)
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  hintText: "Send Message",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            value.text.isEmpty ? const SizedBox() :
                                            Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: IconButton(onPressed: () async{
                                                  try{
                                                  await messages.set({'message': writeMsg.text});
                                                  } catch(e){
                                                    debugPrint("You got an error $e");
                                                  }
                                                }, icon: const Icon(Icons.send, color: Colors.white,)))
                                          ],
                                        );
                                      },
                                    ),
          ],
        ),
        ),
      )),
    );
  }
}