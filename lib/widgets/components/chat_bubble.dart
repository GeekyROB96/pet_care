import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String time;
  final Color backgroundColor;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSender,
    required this.time,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSender
                      ? Color(0xFF500AD2).withOpacity(0.7)
                      : Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(isSender ? 20 : 0),
                    bottomRight: Radius.circular(isSender ? 0 : 20),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '\n',
                        style: TextStyle(fontSize: 4), // For line break
                      ),
                      WidgetSpan(
                        child: Align(
                          alignment: isSender
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          child: Text(
                            time,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
