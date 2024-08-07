import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/model/message_model.dart';

class FireStoreServiceVolunteer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> saveVolunteerDetails({
    required String userId,
    required String name,
    required String email,
    required String phoneNo,
    required String age,
    required String occupation,
    required String aboutMe,
    required bool prefersCat,
    required bool prefersDog,
    required bool prefersBird,
    required bool prefersRabbit,
    required bool prefersOthers,
    required bool providesHomeVisits,
    required bool providesDogWalking,
    required bool providesHouseSitting,
    int? providesHomeVisitsPrice,
    int? providesHouseSittingPrice,
    required String role,
    String? profileImageUrl,
    String? locationCity,
    Map<String, dynamic>? address,
  }) async {
    try {
      String? uid = _firebaseAuth.currentUser?.uid;

      await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .doc(userId)
          .set({
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'age': age,
        'occupation': occupation,
        'aboutMe': aboutMe,
        'prefersCat': prefersCat,
        'prefersDog': prefersDog,
        'prefersBird': prefersBird,
        'prefersRabbit': prefersRabbit,
        'prefersOthers': prefersOthers,
        'providesHomeVisits': providesHomeVisits,
        'providesDogWalking': providesDogWalking,
        'providesHouseSitting': providesHouseSitting,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'locationCity': locationCity,
        'providesHomeVisitsPrice': providesHomeVisitsPrice,
        'providesHouseSittingPrice': providesHouseSittingPrice,
        'address': address,
        'uid': uid,
      });
    } catch (e) {
      print("Error saving User Details $e");
    }
  }

  Future<Map<String, dynamic>?> getVolAddressDetails(String userId) async {
    try {
      if (userId.isEmpty) {
        print("Error: UserId is empty");
        return null;
      }
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('Address') &&
            userData['address'] != null &&
            userData['address'].isNotEmpty) {
          return {
            'area_apartment_road': userData['address'][0]
                ['area_apartment_road'],
            'coordinates': userData['address'][0]['coordinates'],
            'description_directions': userData['address'][0]
                ['description_directions'],
            'house_flat_data': userData['address'][0]['house_flat_data'],
          };
        } else {
          print("Address details not found or empty for user $userId");
          return null;
        }
      }
      return null;
    } catch (e) {
      print("Error getting address details for user $userId: $e");
      return null;
    }
  }

  Future<void> updateVolunteerProfileImage(
      {required String userId, required String imageUrl}) async {
    try {
      await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .doc(userId)
          .update({'imageUrl': imageUrl});
    } catch (e) {
      print("Error updating profile image $e");
    }
  }

  Future<Map<String, dynamic>?> getVolunteerDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .doc(userId)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error getting user details $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllVolunteers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .get();
      List<Map<String, dynamic>> volunteers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print("Fetched ${volunteers.length} volunteers");
      return volunteers;
    } catch (e) {
      print("Error getting all volunteers $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllVolunteersAsc() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .get();
      List<Map<String, dynamic>> volunteers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print("Fetched ${volunteers.length} volunteers");
      return volunteers;
    } catch (e) {
      print("Error getting all volunteers $e");
      return [];
    }
  }

  Future<void> updateOwnerUserUIDs() async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .get();

      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        String uid = userDoc.id;
        await userDoc.reference.update({'uid': uid});
      }
      print('UIDs updated successfully');
    } catch (e) {
      print('Error updating UIDs: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getVolunteersStream() {
    return _firestore
        .collection('users')
        .doc('volunteers')
        .collection('volunteers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message,
      {String? imageUrl}) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverID,
        timestamp: timeStamp,
        message: message,
        imageUrl: imageUrl);

    List<String> ids = [currentUserId, receiverID];
    ids.sort();

    String chatRoomID = ids.join('_');

    await _firestore.collection('chat_rooms').doc(chatRoomID).set({
      'messages': FieldValue.arrayUnion([newMessage.toMap()]),
      'roomId': chatRoomID,
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> getMessages(
      String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();

    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> messages = snapshot.data()!['messages'];
        return messages.map((msg) => msg as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    });
  }

  Future<List<String>> getChatRoomIdsForCurrentUser() async {
    String currentUserId = _firebaseAuth.currentUser?.uid ?? '';

    print("Current uid: $currentUserId");

    if (currentUserId.isEmpty) {
      throw Exception("Current user ID is not available.");
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('chat_rooms')
        .get(); // Retrieve all documents

    List<String> chatRoomIds = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      if (data.containsKey('roomId')) {
        String roomId = data['roomId'] as String;
        print("Room ID: $roomId");

        if (roomId.contains(currentUserId)) {
          List<String> ids = roomId.split('_');
          String otherUserId =
              ids.firstWhere((id) => id != currentUserId, orElse: () => '');

          if (otherUserId.isNotEmpty) {
            chatRoomIds.add(otherUserId);
          }
        }
      }
    }

    return chatRoomIds;
  }

  Future<Map<String, dynamic>?> getVolunteerDetailsByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>?;
      } else {
        print("No volunteer found with email: $email");
        return null;
      }
    } catch (e) {
      print("Error getting volunteer details: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getVolunteerAddressByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null &&
            userData.containsKey('Address') &&
            userData['Address'] != null &&
            userData['Address'].isNotEmpty) {
          return userData['Address'][0] as Map<String, dynamic>?;
        } else {
          print("No address found for volunteer with emailwa $email");
          return null;
        }
      } else {
        print("No volunteer found with email $email");
        return null;
      }
    } catch (e) {
      print("Error getting volunteer address by email $e");
      return null;
    }
  }

Future<void> saveAddress({
  required String userId,
  required String main,
  required String areaApartmentRoad,
  required String coordinates,
  required String descriptionDirections,
  required String city,
  required String state,
  required String pincode,
}) async {
  try {
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc('volunteers')
        .collection('volunteers')
        .doc(userId)
        .get();

    List<Map<String, dynamic>> addresses = [];

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      if (userData.containsKey('Address')) {
        addresses = List<Map<String, dynamic>>.from(userData['Address']);
      }
    }

    Map<String, dynamic> newAddress = {
      'main': main,
      'area_apartment_road': areaApartmentRoad,
      'coordinates': coordinates,
      'description_directions': descriptionDirections,
      'city': city,
      'state': state,
      'pincode': pincode
    };

    if (addresses.isEmpty) {
      addresses.add(newAddress);
    } else {
      addresses[0] = newAddress;
    }

    await _firestore
        .collection('users')
        .doc('volunteers')
        .collection('volunteers')
        .doc(userId)
        .update({'Address': addresses});
  } catch (e) {
    print("Error saving Address Details $e");
  }
}

}
