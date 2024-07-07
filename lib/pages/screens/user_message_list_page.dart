import 'package:flutter/material.dart';
import 'package:pet_care/pages/screens/chat_screen.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

class StatusAndMessagesPage extends StatefulWidget {
  @override
  _StatusAndMessagesPageState createState() => _StatusAndMessagesPageState();
}

class _StatusAndMessagesPageState extends State<StatusAndMessagesPage> {
  final FireStoreServiceVolunteer _firestoreServiceVolunteer =
      FireStoreServiceVolunteer();
  final FirestoreServiceOwner _firestoreServiceOwner = FirestoreServiceOwner();

  late Future<List<String>> _userIdsFuture;

  @override
  void initState() {
    super.initState();
    _userIdsFuture = _firestoreServiceVolunteer.getChatRoomIdsForCurrentUser();
  }

  Widget _buildRequestsList(Future<List<String>> futureRequests) {
    return FutureBuilder<List<String>>(
      future: futureRequests,
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
            return FutureBuilder<Map<String, dynamic>?>(
              future: _firestoreServiceOwner.getOwnerUidemail(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Loading...'),
                      leading: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Owner details not found for $userId'),
                    ),
                  );
                }

                Map<String, dynamic> ownerDetails = snapshot.data!;
                String userEmail = ownerDetails['userEmail'];
                String profileImageUrl = ownerDetails['profileImageUrl'];
                String name = ownerDetails['name'];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: CircleAvatar(
                        backgroundImage: profileImageUrl != null
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                      ),
                      title: Text(name ?? 'No Name'),
                      subtitle: Text('Email: $userEmail'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              name: name ?? 'No Name',
                              profileImageUrl: profileImageUrl ??
                                  'assets/images/default_profile.png',
                              receiverId: userId,
                              receiverEmail: userEmail,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status and Messages'),
        centerTitle: true,
      ),
      body: _buildRequestsList(_userIdsFuture),
    );
  }
}
