import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';

class PetsDetailsGetterProvider extends ChangeNotifier {
  final PetFireStoreService _fireStoreService = PetFireStoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isDataLoaded = false;
  bool _isSinglePetLoaded = false;
  bool get isDataLoaded => _isDataLoaded;
  bool get isSinglePetLoaded => _isSinglePetLoaded;
  var petData;

  List<Map<String, dynamic>> _pets = [];

  List<Map<String, dynamic>> get pets => _pets;

  PetsDetailsGetterProvider() {
    loadPets();
  }

  Future<void> loadPets() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        _pets.clear();

        _pets = await _fireStoreService.getPets(user.email!);
        _isDataLoaded = true;
        notifyListeners();
      } catch (e) {
        print("Error loading pets data: $e");
      }
    } else {
      print("No user logged in.");
    }
  }

  Future<void> navigateAndgetPetByName(
      String petName, String ownermail, BuildContext context) async {
    _isSinglePetLoaded = false;
    notifyListeners();

    navigateToPetProfile(context);

    try {
      petData = await _fireStoreService.getPetDetailsByName(ownermail, petName);
      _isSinglePetLoaded = true;
      notifyListeners();
      print("Pet Data: $petData");
    } catch (e) {
      print("Error fetching pet data: $e");
      _isSinglePetLoaded =
          true; // Ensure to set back to true on error to avoid infinite loading state
      notifyListeners();
    }
  }

  void clearData() {
    _pets = [];
    _isDataLoaded = false;
    notifyListeners();
  }

  void navigateToPetProfile(BuildContext context) {
    Navigator.pushNamed(context, '/petProfile');
  }
}
