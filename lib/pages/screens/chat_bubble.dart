import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String time;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSender,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        constraints: BoxConstraints(maxWidth: 300, minWidth: 70),
        decoration: BoxDecoration(
          color: isSender
              ? Color(0xFF6E9DF5).withOpacity(0.9)
              : Color(0xFFE0EBF6).withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isSender ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isSender ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0), // Add space for the time
              child: Text(
                message,
                style: TextStyle(
                  color: isSender ? Colors.white : Color(0xFF012DBE),
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                time,
                style: TextStyle(
                  color: isSender ? Colors.black87 : Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
