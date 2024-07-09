import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'dart:io';

import 'package:pet_care/services/firestore_service/lost_pet_firestore.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';

class LostPetProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final LostPetFirestore firestoreService = LostPetFirestore();
  final FirestoreServiceOwner _firestoreServiceOwner = FirestoreServiceOwner();

  File? _petImageFile;
  DateTime? _selectedDateTime;
  String? _selectedPet;
  String? _description;
  late String ownerEmail;

  LostPetProvider() {
    ownerEmail = _auth.currentUser!.email!;
  }

  String _mainAddress = '';
  String _apartmentRoad = '';
  String _coordinates = '';
  String _descriptionDirections = '';
  String _cityName = '';
  String _stateName = '';
  String _pincode = '';

  Map<String, dynamic> _address = {}; // Changed to Map

  // Getters
  File? get petImageFile => _petImageFile;
  DateTime? get selectedDateTime => _selectedDateTime;
  String? get selectedPet => _selectedPet;
  String? get description => _description;
  String get mainAddress => _mainAddress;
  String get apartmentRoad => _apartmentRoad;
  String get coordinates => _coordinates;
  String get descriptionDirections => _descriptionDirections;
  String get cityName => _cityName;
  String get stateName => _stateName;
  String get pincode => _pincode;
  Map<String, dynamic> get address => _address; // Changed getter type

  // Setters
  set image(File? newImage) {
    _petImageFile = newImage;
    notifyListeners();
  }

  set selectedDateTime(DateTime? newDateTime) {
    _selectedDateTime = newDateTime;
    notifyListeners();
  }

  set selectedPet(String? newPet) {
    _selectedPet = newPet;
    notifyListeners();
  }

  set description(String? newDescription) {
    _description = newDescription;
    notifyListeners();
  }

  Map<String, dynamic> lostaddress = {};

  Future<void> getLostAddress() async {
    try {
      lostaddress =
          (await _firestoreServiceOwner.getLostAddressByEmail(ownerEmail)) ??
              {};
      print("Lost Address is $lostaddress");
      notifyListeners();
    } catch (e) {
      print("Error getting lost address: $e");
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = 'lost_pet_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = _storage.ref().child('LostPets').child(fileName);

    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<void> saveLostPet(BuildContext context) async {
    if (_petImageFile != null &&
        _selectedDateTime != null &&
        _selectedPet != null) {
      try {
        print("All required fields are present, proceeding with save");
        String petImageUrl = await uploadImage(_petImageFile!);
        print("Image uploaded successfully: $petImageUrl");

        await getLostAddress();
        await firestoreService.saveLostPet(
          ownerEmail: ownerEmail,
          petName: _selectedPet!,
          petImageUrl: petImageUrl,
          lastSeen:
              DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime!),
          description: _description ?? '',
          address: lostaddress,
        );

        print("Data saved to Firestore successfully");
        ToastNotification.showToast(
          context,
          message: 'Request Submitted Successfully!',
          type: ToastType.positive,
        );
      } catch (e) {
        print("Error in saveLostPet: $e");
        ToastNotification.showToast(
          context,
          message: 'Error $e',
          type: ToastType.error,
        );
      }
    } else {
      print("Missing required fields");
      print("Pet Image File: ${_petImageFile != null}");
      print("Selected Date Time: ${_selectedDateTime != null}");
      print("Selected Pet: ${_selectedPet != null}");
      ToastNotification.showToast(
        context,
        message: 'Please fill all the details',
        type: ToastType.error,
      );
    }
    print("Exiting saveLostPet");
  }
}
