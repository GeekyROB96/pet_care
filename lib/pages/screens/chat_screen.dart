import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/model/message_model.dart';
import 'package:pet_care/services/chat/chat_service.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:pet_care/services/auth_service.dart/owner_authservice.dart';
import 'package:pet_care/services/auth_service.dart/volunteer_authservice.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;

  ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late FirestoreServiceOwner _firestoreServiceOwner;
  late FireStoreServiceVolunteer _firestoreServiceVolunteer;
  late AuthServiceOwner _authServiceOwner;
  late AuthServiceVolunteer _authServiceVolunteer;

  String _currentUserId = '';
  String _currentUserRole = '';

  @override
  void initState() {
    super.initState();
    _authServiceOwner = AuthServiceOwner();
    _authServiceVolunteer = AuthServiceVolunteer();

    _currentUserId = _authServiceOwner.getCurrentUserId() ??
        _authServiceVolunteer.getCurrentUserId() ??
        '';

    _getCurrentUserRole();
  }

  Future<void> _getCurrentUserRole() async {
    try {
      _currentUserRole = await _authServiceOwner.getCurrentUserRole() ??
          await _authServiceVolunteer.getCurrentUserRole() ??
          '';

      if (_currentUserRole == 'owner') {
        _firestoreServiceOwner = FirestoreServiceOwner();
      } else if (_currentUserRole == 'volunteer') {
        _firestoreServiceVolunteer = FireStoreServiceVolunteer();
      }

      setState(() {});
    } catch (e) {
      print("Error getting user Role:  $e");
    }
  }

  // void _sendMessage() {
  //   String messageText = _messageController.text.trim();

  //   if (messageText.isNotEmpty) {
  //     String senderEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  //     Message newMessage = Message(
  //         senderId: _currentUserId,
  //         receiverId: widget.receiverId,
  //         message: messageText,
  //         timestamp: Timestamp.now(),
  //         senderEmail: senderEmail);

  //     if (_currentUserRole == 'owner') {
  //       _firestoreServiceOwner.sendMessage(widget.receiverId, newMessage);
  //     } else if (_currentUserRole == 'volunteer') {
  //       _firestoreServiceVolunteer.sendMessage(widget.receiverId, newMessage);
  //     }
  //   }
  // }


  void _sendMessage() {
  String messageText = _messageController.text.trim();
  if (messageText.isNotEmpty) {
    if (_currentUserRole == 'owner') {
      _firestoreServiceOwner.sendMessage(widget.receiverId, messageText);
    } else if (_currentUserRole == 'volunteer') {
      _firestoreServiceVolunteer.sendMessage(widget.receiverId, messageText);
    }

    _messageController.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _currentUserRole == 'owner'
                  ? _firestoreServiceOwner.getMessages(
                      _currentUserId, widget.receiverId)
                  : _firestoreServiceVolunteer.getMessages(
                      _currentUserId, widget.receiverId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                var messages = snapshot.data!.docs
                    .map((doc) =>
                        Message.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text(message.senderEmail),
                      subtitle: Text(message.message),
                      trailing: Text(message.timestamp.toDate().toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter Message'),
                  ),
                ),

                IconButton(onPressed: _sendMessage, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
