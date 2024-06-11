import 'package:chat_app/views/view_image/view_image_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final Color color;
  final Timestamp timestamp;
  final String userEmail;
  const ChatBubble({super.key, required this.message, required this.color, required this.timestamp, required this.userEmail});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return isValidUrl(widget.message) ? Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: (){
            print("True Image");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen(message: widget.message, userEmail: widget.userEmail,)),
            );
          },
          child: SizedBox(
              width: 300,
              height: 150,
              child: Image.network(widget.message)
          ),
        ),
        Text(formatTimestamp(widget.timestamp, context), style: const TextStyle(fontSize: 12),),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: (){
            print("False message");
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: widget.color,
            ),
            child: Text(widget.message, style: const TextStyle(fontSize: 16.0, color: Colors.black),),
          ),
        ),
        Text(formatTimestamp(widget.timestamp, context), style: const TextStyle(fontSize: 12),),
      ],
    );
  }

  bool isValidUrl(String text) {
return Uri.parse(text).isAbsolute;
}

  String formatTimestamp(Timestamp timestamp, BuildContext context) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = TimeOfDay.fromDateTime(dateTime).format(context);
    return formattedTime;
  }
}