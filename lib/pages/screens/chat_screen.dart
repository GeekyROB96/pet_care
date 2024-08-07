import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/constants/zego_credentials.dart';
import 'package:pet_care/model/message_model.dart';
import 'package:pet_care/pages/screens/chat_bubble.dart';
import 'package:pet_care/provider/owner_provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/volunteer_provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/chat/chat_service.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
//import 'package:pet_care/widgets/components/chat_bubble.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

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
    required this.profileImageUrl,
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

  String? currentUserName;
  String? currentUserId;
  String? callId;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _authServiceOwner = AuthServiceOwner();
    _authServiceVolunteer = AuthServiceVolunteer();

    _getCurrentUserId();

    myFocusMode.addListener(() {
      if (myFocusMode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});

      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: ZegoCredentials.appID /*input your AppID*/,
        appSign: ZegoCredentials.appSign /*input your AppSign*/,
        userID: _currentUserId,
        userName: currentUserName!,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    });
  }

  Future<void> _getCurrentUserId() async {
    _currentUserId = _authServiceOwner.getCurrentUserId() ??
        _authServiceVolunteer.getCurrentUserId() ??
        '';

    await _getCurrentUserRole(); // Wait for user role before continuing
    await callSetters(); // Wait for setters to complete before setting state

    setState(() {}); // Update the UI after initialization
  }

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<String?> uploadImage(File image) async {
    try {
      if (image != null) {
        String image_path =
            'chat_images/${DateTime.now().millisecondsSinceEpoch}.png';

        UploadTask uploadTask = _storage.ref().child(image_path).putFile(image);

        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        return downloadURL;
      }
    } catch (e) {
      print("Error sending image $e");
      return null;
    }
  }

 Future<void> _sendImage() async {
    File? image = await pickImage();

    if (image != null) {
      bool? confirmSend = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Send Image"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(image),
                  SizedBox(height: 20),
                  Text("Do you want to send this image?"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Send"),
              ),
            ],
          );
        },
      );

      if (confirmSend == true) {
        String? imageUrl = await uploadImage(image);

          if (imageUrl != null) {
        if (_currentUserRole == 'owner')
          await _firestoreServiceOwner.sendMessage(widget.receiverId, "",
              imageUrl: imageUrl);
        

        else if (_currentUserRole == 'volunteer') 
        await _firestoreServiceVolunteer.sendMessage(widget.receiverId, "", imageUrl: imageUrl);
      
      }
        }
      }
    }
  

  Future<void> callSetters() async {
    final ownerProvider =
        await Provider.of<OwnerDetailsGetterProvider>(context, listen: false);
    final volunteerProvider = await Provider.of<VolunteerDetailsGetterProvider>(
        context,
        listen: false);

    if (_currentUserRole == 'owner') {
      ownerProvider.loadUserProfile(); // : .'
      currentUserName = ownerProvider.name;
      currentUserId = ownerProvider.uid;
    }

    if (_currentUserRole == 'volunteer') {
      volunteerProvider.loadVolunteerDetails();
      currentUserName = volunteerProvider.name;
      currentUserId = volunteerProvider.uid;
    }

    String? cId = currentUserId; // Use currentUserId directly
    String? rId = widget.receiverId; // Or use widget.receiverId

    // Create a list and filter out null values :(
    List<String> ids = [];
    if (cId != null) ids.add(cId);
    if (rId != null) ids.add(rId);

    // Sort the list
    ids.sort();

    callId = ids.join('_');

    print(ids);
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

  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  @override
  void dispose() {
    _messageController.dispose();
    myFocusMode.dispose();
    onUserLogout();
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
        title: Row(children: [
          CircleAvatar(
            backgroundImage: widget.profileImageUrl.startsWith('http')
                ? NetworkImage(widget.profileImageUrl)
                : AssetImage(widget.profileImageUrl) as ImageProvider,
          ),
          SizedBox(width: 10),
          Text(widget.name),
          SizedBox(width: 20),
          const Spacer(),
          actionButton(true)
        ]),
        backgroundColor: Color(0xFFC5B4EC).withOpacity(0.2),
        foregroundColor: Colors.black,
        elevation: 5,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _currentUserRole == 'owner'
                    ? _firestoreServiceOwner.getMessages(
                        _currentUserId, widget.receiverId)
                    : _firestoreServiceVolunteer.getMessages(
                        _currentUserId, widget.receiverId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var messages = snapshot.data!
                      .map((msgData) => Message.fromMap(msgData))
                      .toList();

                  String? lastDisplayedDate;
                  return ListView.builder(
                    controller: _scrollController,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Chip(
                                  label: Text(messageDate),
                                ),
                              ),
                            ),
                          if (message.imageUrl != null)
                          ChatBubble(
                            message: message.message,
                            isSender: isSender,
                            time: messageTime,
                            imageUrl: message.imageUrl,
                          )
                        else
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
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(left: 20, right: 10),
              controller: _messageController,
              hintText: "Type a message",
              obsText: false,
              focusNode: myFocusMode,
            ),
          ),
          IconButton(
            icon: Icon(Icons.photo, color: Color(0xFF0C39EE), size: 30),
            onPressed: _sendImage,
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF0C39EE), size: 30),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(bool isvideo) =>
      ZegoSendCallInvitationButton(
        isVideoCall: isvideo,
        resourceID: "pet_buddy",
        invitees: [
          ZegoUIKitUser(
            id: widget.receiverId,
            name: widget.receiverEmail,
          ),
        ],
      );
}
