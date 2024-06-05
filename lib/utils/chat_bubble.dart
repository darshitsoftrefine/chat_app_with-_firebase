import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final Timestamp timestamp;
  const ChatBubble({super.key, required this.message, required this.color, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return isValidUrl(message) ? Container(
        width: 300,
        height: 150,
        child: Image.network(message)) : Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: Column(
        children: [
          Text(message, style: TextStyle(fontSize: 16.0, color: Colors.black),),
          Text(formatTimestamp(timestamp), style: TextStyle(fontSize: 8),),
        ],
      ),
    );
  }

  bool isValidUrl(String text) {
return Uri.parse(text).isAbsolute;
}


  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }
}