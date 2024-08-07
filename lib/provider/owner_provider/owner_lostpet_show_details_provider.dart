import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/services/firestore_service/lost_pet_firestore.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';

class OwnerLostPetShowDetailsProvider extends ChangeNotifier {
  final LostPetFirestore _lostPetFirestore = LostPetFirestore();
  final PetFireStoreService _petFireStoreService = PetFireStoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? lostPetData;
  Map<String, dynamic>? _pet;
  Map<String, dynamic>? get pet => _pet;
  String? _petName;
  String? _ownerEmail;

  Future<void> loadPetDataByPetId(String petId) async {
    try {
      // Check if the user is logged in
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No user is logged in');
        return;
      }

      lostPetData = await _lostPetFirestore.getLostPetbyId(petId);
      if (lostPetData != null) {
        _petName = lostPetData!['petName'];
        _ownerEmail = lostPetData!['ownerEmail'];
        notifyListeners();
      } else {
        print("Lost pet data not found");
      }
    } catch (e) {
      print('Error fetching lost pet by ID: $e');
    }
  }

  Future<void> getPetData() async {
    try {
      // Check if the user is logged in
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No user is logged in');
        return;
      }

      if (_ownerEmail != null && _petName != null) {
        _pet = await _petFireStoreService.getPetDetailsByName(
            _ownerEmail!, _petName!);
        notifyListeners();
      } else {
        print('Owner email or pet name is null');
      }
    } catch (e) {
      print('Error fetching pet data: $e');
      throw e; // Rethrow the exception to maintain the Future<void> return type
    }
  }
}
