import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final Timestamp timestamp;
  const ChatBubble({super.key, required this.message, required this.color, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return isValidUrl(message) ? Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
            width: 300,
            height: 150,
            child: Image.network(message)),
        Text(formatTimestamp(timestamp, context), style: const TextStyle(fontSize: 12),),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: color,
          ),
          child: Text(message, style: const TextStyle(fontSize: 16.0, color: Colors.black),),
        ),
        Text(formatTimestamp(timestamp, context), style: const TextStyle(fontSize: 12),),
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