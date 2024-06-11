import 'dart:io';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/utils/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  //final User = FirebaseAuth.instance.currentUser;
  String imageUrl =  '';
  String docUrl = '';


  void sendMessages(String url) async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessages(widget.receiverUserId, url);
      _messageController.clear();
    } else {
      await _chatService.sendMessages(widget.receiverUserId, url);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 1,),
            Text(widget.receiverUserEmail),
          ],
        ),
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
    formatTimestamp(data['timestamp']);
    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
        Text(data['senderEmail']),
        const SizedBox(height: 5.0,),
        ChatBubble(message: data['message'], color: data['senderId'] == _firebaseAuth.currentUser!.uid ? Colors.lightBlueAccent : Colors.lightGreen, timestamp: data['timestamp'], userEmail: widget.receiverUserEmail,),
        //Text(formatTimestamp(data['timestamp']).toString()),
      ],),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(child: inputDetails(_messageController, "Type Here ..")),
          IconButton(onPressed: (){ sendMessages(_messageController.text); }
          , icon: const Icon(Icons.send, size: 30.0,))
        ],
      ),
    );
  }

  TextField inputDetails(TextEditingController name, String label) {
    return TextField(
            controller: name,
      decoration: InputDecoration(
        prefixIcon: IconButton(onPressed: () {
         imageUpload();

        }, icon: const Icon(Icons.image)),

        suffixIcon: IconButton(onPressed: (){
          documentUpload();
        }, icon: Icon(Icons.picture_as_pdf)),

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

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('MMMMd'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

  Widget showDocumentBubble() {
    return GestureDetector(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: const Row(
            children: [
              Icon(Icons.picture_as_pdf, size: 30.0,),
              Text("Document")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> documentUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions: ['pdf', 'doc']);

    File doc = File(result!.files.single.path!);
    debugPrint(doc.path);
    String uniqueDocName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirDoc = referenceRoot.child('documents');
    Reference referenceImageToUpload = referenceDirDoc.child(uniqueDocName);

    try {
      await referenceImageToUpload.putFile(File(doc.path));
      docUrl = await referenceImageToUpload.getDownloadURL();
      debugPrint("Document upload $docUrl");
      sendMessages(docUrl);
    } catch(e) {
      print("Hello Error");
      debugPrint(e.toString());
    }
  }

  Future<void> imageUpload() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    debugPrint(file!.path);
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoots = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoots.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      debugPrint("Image upload $imageUrl");
      sendMessages(imageUrl);
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}