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
  }) async {
    try {
      String? uid = _firebaseAuth
          .currentUser?.uid; // Retrieve the UID of the current user

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
        'uid': uid
        
      });
    } catch (e) {
      print("Error saving User Details $e");
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

  Future<void> updateOwnerUserUIDs() async {
    try {
      // Get all users in the pet_owners sub-collection
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .doc('pet_owners')
          .collection('pet_owners')
          .get();

      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        // Assuming UID can be retrieved or already known
        String uid = userDoc.id; // Using document ID as UID
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

  Future<void> sendMessage(String recieverID, message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: recieverID,
        timestamp: timeStamp,
        message: message);

    List<String> ids = [currentUserId, recieverID];
    ids.sort();

    String chatRoomID = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }


   Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chat room Id for two users
    List<String> ids = [userID, otherUserID];
    ids.sort();

    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
