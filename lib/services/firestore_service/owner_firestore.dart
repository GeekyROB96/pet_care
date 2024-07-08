
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/model/message_model.dart';

class FirestoreServiceOwner {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> saveUserDetails({
    required String userId,
    required String name,
    required String email,
    required String phoneNo,
    required String age,
    required String occupation,
    required String role,
    String? locationCity,
    String? profileImageUrl,
    Map<String, dynamic>? address,
  }) async {
    try {
      String? uid = _firebaseAuth.currentUser?.uid;

      await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .set({
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'age': age,
        'occupation': occupation,
        'role': role,
        'locationCity': locationCity,
        'profileImageUrl': profileImageUrl,
        'address': address,
        'uid': uid
      });
    } catch (e) {
      print("Error saving User Details $e");
    }
  }

  Future<Map<String, dynamic>?> getAddressDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> addresses = userData['Address'] ?? [];

        if (addresses.isNotEmpty) {
          // Assuming only one address is stored, fetch the first one
          Map<String, dynamic> address = addresses[0];
          return {
            'area_apartment_road': address['area_apartment_road'],
            'coordinates': address['coordinates'],
            'description_directions': address['description_directions'],
            'house_flat_data':
                address['main'], // Adjust based on your data structure
            'city': address['city'],
            'state': address['state'],
            'pincode': address['pincode'],
          };
        } else {
          print('No address found for user with ID: $userId');
          return null;
        }
      } else {
        print('User document not found for ID: $userId');
        return null;
      }
    } catch (e) {
      print("Error getting address details: $e");
      return null;
    }
  }

  Future<void> updateProfileImage(
      {required String userId, required String imageUrl}) async {
    try {
      await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print("Error updating profile image $e");
    }
  }

  Future<Map<String, dynamic>?> getOwnerDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .get();

      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error getting user details $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOwnerUidemail(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String userEmail = userData['email'] ?? '';
        String profileImageUrl = userData['profileImageUrl'] ?? '';
        String name = userData['name']; // Add this line
        return {
          'userId': userId,
          'userEmail': userEmail,
          'profileImageUrl': profileImageUrl,
          // Include profileImageUrl in the returned map
          'name': name
        };
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user details $e");
      return null;
    }
  }

  Future<void> updateOwnerUserUIDs() async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
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

  Stream<List<Map<String, dynamic>>> getPetOwnersStream() {
    return _firestore
        .collection('users')
        .doc('pet_owners')
        .collection('pet_owners')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message,
      {String? imageUrl}) async {
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
        message: message);

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

  Future<Map<String, dynamic>?> getOwnerDetailsByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String profileImageUrl = userData['profileImageUrl'] ?? '';
        String name = userData['name'] ?? '';
        String location = userData['locationCity'] ?? '';

        return {
          'name': name,
          'profileImageUrl': profileImageUrl,
          'locationCity': location,
        };
      } else {
        print('No user found with email: $email');
        return null;
      }
    } catch (e) {
      print("Error getting user details by email $e");
      return null;
    }
  }

  Future<void> saveAddress(
      {required String userId,
      required String main,
      required String areaApartmentRoad,
      required String coordinates,
      required String descriptionDirections,
      required String city,
      required String state,
      required String pincode}) async {
    try {
      await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .doc(userId)
          .update({
        'Address': {
          'main': main,
          'area_apartment_road': areaApartmentRoad,
          'coordinates': coordinates,
          'description_directions': descriptionDirections,
          'city': city,
          'state': state,
          'pincode': pincode
        }
      });
    } catch (e) {
      print("Error saving Address Details $e");
    }
  }
}




