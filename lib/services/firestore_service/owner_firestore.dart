import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserDetails(
      {required String userId,
      required String name,
      required String email,
      required String phoneNo,
      required String age,
      required String occupation,
      required String role,
      String? locationCity,
      String? profileImageUrl,
      String? uid}) async {
    try {
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

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
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
}
