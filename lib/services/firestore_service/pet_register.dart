import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

 Future<bool> isPetNameDuplicate(String ownerEmail, String petName) async {
 
  
  try {
    QuerySnapshot query = await _fireStore
        .collection('pets')
        .doc(ownerEmail)
        .collection('pets')
        .where('petName', isEqualTo: petName)
        .get();

    return query.docs.isNotEmpty;
  } catch (e) {
    print('Error checking for duplicate pet name: $e');
    return false;
  }
}


  Future<void> savePetDetails({
    required String ownerEmail,
    required String petName,
    required String breed,
    required String age,
    required String gender,
    required String imagePath,
    required bool friendlyWithChildren,
    required bool friendlyWithOtherPets,
    required bool houseTrained,
    required int walksPerDay,
    required String energyLevel,
    required String feedingSchedule,
    required bool canBeLeftAlone,
    required String selectedPetType,
    String? aboutPet, 
    int? weight

  }) async {
    try {
      await _fireStore
          .collection('pets')
          .doc(ownerEmail)
          .collection('pets')
          .add({
        'ownerEmail': ownerEmail,
        'petName': petName,
        'breed': breed,
        'age': age,
        'gender': gender,
        'imagePath': imagePath,
        'friendlyWithChildren': friendlyWithChildren,
        'friendlyWithOtherPets': friendlyWithOtherPets,
        'houseTrained': houseTrained,
        'walksPerDay': walksPerDay,
        'energyLevel': energyLevel,
        'feedingSchedule': feedingSchedule,
        'canBeLeftAlone': canBeLeftAlone,
        'selectedPetType': selectedPetType,
        'aboutPet' : aboutPet,
        'weight' : weight
      });
    } catch (e) {
      print('Error saving pet details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPets(String ownerEmail) async {
    try {
      QuerySnapshot query = await _fireStore
          .collection('pets')
          .doc(ownerEmail)
          .collection('pets')
          .get();

      return query.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching pets! : $e');
      return [];
    }
  }

  Future<void> addPet(String ownerEmail, Map<String, dynamic> petData) async {
    try {
      await _fireStore
          .collection('pets')
          .doc(ownerEmail)
          .collection('pets')
          .add(petData);
    } catch (e) {
      print('Error adding pet: $e');
    }
  }


   Future<Map<String, dynamic>?> getPetDetailsByName(String ownerEmail, String petName) async {
    try {
      QuerySnapshot query = await _fireStore
          .collection('pets')
          .doc(ownerEmail)
          .collection('pets')
          .where('petName', isEqualTo: petName)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching pet details by name: $e');
      return null;
    }
  }
}
