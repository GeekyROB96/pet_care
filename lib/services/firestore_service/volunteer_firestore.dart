import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    required String role,
    String? profileImageUrl,
    String? locationCity,
    int? minPrice,
    int? maxPrice,
  }) async {
    try {
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
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'locationCity': locationCity
      });
    } catch (e) {
      print("Error saving User Details $e");
    }
  }

  Future<void> updateVolunteerProfileImage(
      {required String userId, required String imageUrl}) async {
    try {
      await _firestore
          .collection('users')
          .doc('volunteers') // Corrected collection name
          .collection('volunteers') // Corrected collection name
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

  // Future<List<Map<String, dynamic>>> getAllVolunteers() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('users')
  //         .doc('volunteers')
  //         .collection('volunteers')
  //         .get();
  //     return querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();
  //   } catch (e) {
  //     print("Error getting all volunteers $e");
  //     return [];
  //   }
  // }

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
          .orderBy('minPrice',
              descending: false) // Sorting by minPrice in ascending order
          .get();
      List<Map<String, dynamic>> volunteers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print("Fetched ${volunteers.length} volunteers sorted ascending");
      return volunteers;
    } catch (e) {
      print("Error getting all volunteers $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllVolunteersDsc() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .orderBy('minPrice',
              descending: true) // Sorting by minPrice in descending order
          .get();
      List<Map<String, dynamic>> volunteers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print("Fetched ${volunteers.length} volunteers sorted descending");
      return volunteers;
    } catch (e) {
      print("Error getting all volunteers $e");
      return [];
    }
  }
}
