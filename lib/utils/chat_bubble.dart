import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  const ChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: isValidUrl(message) ? Container(
        width: 300,
        height: 150,
        child: Image.network(message)) : Text(message, style: TextStyle(fontSize: 16.0, color: Colors.black),),
    );
  }

  bool isValidUrl(String text) {
return Uri.parse(text).isAbsolute;
}
}