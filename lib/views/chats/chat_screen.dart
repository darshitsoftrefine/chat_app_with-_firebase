import 'dart:io';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/utils/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatScreen({super.key, required this.receiverUserEmail, required this.receiverUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String imageUrl =  '';

  void sendMessages() async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessages(widget.receiverUserId, _messageController.text);
      _messageController.clear();
    } else {
      _messageController.text = imageUrl;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserId, _firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) { 
      if(snapshot.hasError) {
        return Text('Error ${snapshot.error}');
      } 

      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator(),);
      }

      return ListView(
        reverse: true,
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );

     }, 
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
        Text(data['senderEmail']),
        const SizedBox(height: 5.0,),
        ChatBubble(message: data['message'], color: data['senderId'] == _firebaseAuth.currentUser!.uid ? Colors.lightBlueAccent : Colors.lightGreen, timestamp: data['timestamp'],),
        const Icon(Icons.done_all)
        //Text(data['timestamp'].())
        //data['imageUrl'] == "" ? Container() : Image.network(data['imageUrl'])
      ],),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(child: inputDetails(_messageController, "Type Here ..")),
          IconButton(onPressed: sendMessages
          , icon: const Icon(Icons.send, size: 30.0,))
        ],
      ),
    );
  }

  TextField inputDetails(TextEditingController name, String label) {
    return TextField(
            controller: name,
      decoration: InputDecoration(
        prefixIcon: IconButton(onPressed: () async{

          ImagePicker imagePicker = ImagePicker();
          XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
          print(file!.path);
          String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('images');
          Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

          try {
           await referenceImageToUpload.putFile(File(file.path));
           imageUrl = await referenceImageToUpload.getDownloadURL();
           print("Image upload $imageUrl");
          } catch(e) {
            print(e.toString());
          }
        }, icon: const Icon(Icons.image)),

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