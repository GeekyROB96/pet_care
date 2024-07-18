import 'package:cloud_firestore/cloud_firestore.dart';

class LostPetFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveLostPet(
      {required String ownerEmail,
      required String petName,
      required String petImageUrl,
      required String lastSeen,
      required String description,
      required Map<String, dynamic> address}) async {
    try {
      DocumentReference petRef = _firestore.collection('LostPet').doc();
      String petId = petRef.id;

      await petRef.set({
        'petId': petId,
        'ownerEmail': ownerEmail,
        'petName': petName,
        'petImageUrl': petImageUrl,
        'lastSeen': lastSeen,
        'description': description,
        'address': address
      });
    } catch (e) {
      print('Error saving lost pet: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getLostPetbyId(String petId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('LostPet').doc('petId').get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print("No bookings found");
        return null;
      }
    } catch (e) {
      print('Error getting lost pet: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getLostPetbyOwnerEmail(
      String ownerEmail) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('LostPet')
          .where('ownerEmail', isEqualTo: ownerEmail)
          .get();

      return querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting lost pet: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllLostPets() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('LostPet').get();

      return querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting lost pet: $e');
      return [];
    }
  }
}
