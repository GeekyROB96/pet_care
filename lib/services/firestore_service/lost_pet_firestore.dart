import 'package:cloud_firestore/cloud_firestore.dart';

class LostPetFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveLostPet({
    required String ownerEmail,
    required String petName,
    required String petImageUrl,
    required String lastSeen,
    required String description,
    required Map<String,dynamic> address
  }) async {
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
         'address' : address
          
        
      });
    } catch (e) {
      print('Error saving lost pet: $e');
      throw e;
    }
  }
}
