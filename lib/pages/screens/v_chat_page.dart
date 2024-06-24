// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pet_care/model/message_model.dart';
// import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
// import 'call_page.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverId;
//   final String receiverName;
//   final String receiverProfileImageUrl;

//   const ChatPage({
//     required this.receiverId,
//     required this.receiverName,
//     required this.receiverProfileImageUrl,
//   });

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final FireStoreServiceVolunteer _firestoreService = FireStoreServiceVolunteer();
//   final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   String? _callId;
//   String? _currentUserName;
//   String? _currentUserEmail;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCallData();
//   }

//   void _initializeCallData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUserName = user.displayName;
//         _currentUserEmail = user.email;
//         _callId = '${user.uid}_${widget.receiverId}';
//       });
//     }
//   }

//   void _sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       _firestoreService.sendMessage(widget.receiverId, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.receiverProfileImageUrl.isNotEmpty
//                   ? NetworkImage(widget.receiverProfileImageUrl)
//                   : AssetImage('assets/default_avatar.png') as ImageProvider,
//             ),
//             SizedBox(width: 10),
//             Text(widget.receiverName),
//             SizedBox(width: 20),
//             IconButton(
//               icon: Icon(Icons.video_call),
//               onPressed: () {
//                 if (_callId != null && _currentUserName != null && _currentUserId != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CallPage(
//                         callID: _callId!,
//                         username: _currentUserName!,
//                         userId: _currentUserId!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   print('Data not yet available');
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestoreService.getMessages(_currentUserId, widget.receiverId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();

//                 var messages = snapshot.data!.docs.map((doc) {
//                   var data = doc.data() as Map<String, dynamic>;
//                   return Message(
//                     senderId: data['senderId'],
//                     senderEmail: data['senderEmail'],
//                     receiverId: data['receiverId'],
//                     timestamp: data['timestamp'],
//                     message: data['message'],
//                   );
//                 }).toList();

//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     bool isSender = message.senderId == _currentUserId;
//                     return ListTile(
//                       title: Align(
//                         alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: isSender ? Colors.blue : Colors.grey,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             message.message,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: 'Enter your message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
