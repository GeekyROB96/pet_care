import 'package:flutter/material.dart';
import 'package:pet_care/pages/screens/chat_screen.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

class UserListMessage extends StatefulWidget {
  @override
  _UserListMessageState createState() => _UserListMessageState();
}

class _UserListMessageState extends State<UserListMessage> {
  late Future<List<String>> _userIdsFuture;
  final FireStoreServiceVolunteer _firestoreServiceVolunteer =
      FireStoreServiceVolunteer();
  final FirestoreServiceOwner _firestoreServiceOwner = FirestoreServiceOwner();

  @override
  void initState() {
    super.initState();
    _userIdsFuture = _firestoreServiceVolunteer.getChatRoomIdsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List Messages'),
      ),
      body: FutureBuilder<List<String>>(
        future: _userIdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user IDs found.'));
          }

          List<String> userIds = snapshot.data!;

          return ListView.builder(
            itemCount: userIds.length,
            itemBuilder: (context, index) {
              String userId = userIds[index];
              return ListTile(
                title: Text('User ID: $userId'),
                onTap: () async {
                  Map<String, dynamic>? ownerDetails =
                      await _firestoreServiceOwner.getOwnerUidemail(userId);

                  if (ownerDetails != null) {
                    String userId = ownerDetails['userId'];
                    String userEmail = ownerDetails['userEmail'];
                    String profileImageUrl = ownerDetails['profileImageUrl'];
                    String name = ownerDetails['name'];

                    // Display userId, userEmail, and profileImageUrl

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          name: name ?? 'No Name',
                          profileImageUrl: profileImageUrl ??
                              'assets/images/default_profile.png', // Provide a default image if null
                          receiverId: userId,
                          receiverEmail: userEmail,
                        ),
                      ),
                    );
                  } else {
                    // Handle case where details are not found
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Owner details not found for $userId'),
                    ));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
