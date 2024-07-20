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

  Future<void> updateLostPetAddress({
    required String petId,
    required String main,
    required String areaApartmentRoad,
    required String coordinates,
    required String descriptionDirections,
    required String city,
    required String state,
    required String pincode,
  }) async {
    try {
      DocumentReference petRef = _firestore.collection('LostPet').doc(petId);

      await petRef.update({
        'updatedaddress': {
          'main': main,
          'areaApartmentRoad': areaApartmentRoad,
          'coordinates': coordinates,
          'descriptionDirections': descriptionDirections,
          'city': city,
          'state': state,
          'pincode': pincode,
        },
      });
    } catch (e) {
      print('Error updating lost pet  updated address: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getLostPetbyId(String petId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('LostPet')
          .where('petId', isEqualTo: petId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("No lost pet found");
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
