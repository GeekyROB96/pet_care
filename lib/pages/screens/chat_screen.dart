import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/model/message_model.dart';
import 'package:pet_care/services/chat/chat_service.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

import 'package:pet_care/widgets/components/chat_bubble.dart';
import 'package:pet_care/widgets/components/textfield.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;
  final String profileImageUrl;
  final String name;

  ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverEmail,
    required this.name,
    required this.profileImageUrl
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

    Timer? _timer;



    FocusNode myFocusMode = FocusNode();

  @override
  void initState() {
    super.initState();
    _authServiceOwner = AuthServiceOwner();
    _authServiceVolunteer = AuthServiceVolunteer();

    _currentUserId = _authServiceOwner.getCurrentUserId() ??
        _authServiceVolunteer.getCurrentUserId() ??
        '';

    _getCurrentUserRole();

    myFocusMode.addListener(() {
      if (myFocusMode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

     _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }



  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();

    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return 'Today';
    } else if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM yyyy').format(date);
    }
  }

  String _formatTime(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();

    DateTime now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day &&
        date.hour == now.hour &&
        date.minute == now.minute) {
      return 'now';
    } else {
      return DateFormat("HH:mm").format(date);
    }
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
  void dispose() {
    _messageController.dispose();
    myFocusMode.dispose();
    _timer?.cancel(); // Cancel the timer when the widget is disposed

    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
           CircleAvatar(
            backgroundImage: widget.profileImageUrl.startsWith('http')
              ? NetworkImage(widget.profileImageUrl)
              : AssetImage(widget.profileImageUrl) as ImageProvider,
           ),
              SizedBox(width: 10,),
             Text(widget.name)
             ]),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 5,
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

                String? lastDisplayedDate;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSender = message.senderId == _currentUserId;
                    String messageDate = _formatDate(message.timestamp);
                    String messageTime = _formatTime(message.timestamp);

                    bool shouldDisplayDate = lastDisplayedDate != messageDate;
                    lastDisplayedDate = messageDate;

                    return Column(
                      children: [
                        if (shouldDisplayDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Chip(
                                label: Text(messageDate),
                              ),
                            ),
                          ),
                        ChatBubble(
                          message: message.message,
                          isSender: isSender,
                          time: messageTime,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(left: 25, right: 10),
              controller: _messageController,
              hintText: "Type a message",
              obsText: false,
              focusNode: myFocusMode,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29), color: Colors.blue),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
