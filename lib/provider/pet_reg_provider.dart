import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_reg_provider.dart';
import 'package:pet_care/provider/pets_provider.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';
import 'package:provider/provider.dart';

class PetRegistrationProvider with ChangeNotifier {
  XFile? _image;
  String? _petName;
  String? _breed;
  String? _age;
  int? _weight;
  String? _gender;
  String? _aboutPet;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _friendlyWithChildren = false;
  bool _friendlyWithOtherPets = false;
  bool _houseTrained = false;
  int _walksPerDay = 1;
  String _energyLevel = 'Low';
  String? _feedingSchedule;
  bool _canBeLeftAlone = false;

  XFile? get image => _image;
  String? get petName => _petName;
  String? get breed => _breed;
  String? get age => _age;
  int? get weight => _weight;
  String? get gender => _gender;
  String? get aboutPet => _aboutPet;

  File? _profileImageFile;

  File? get profileImageFile => _profileImageFile;

  bool get friendlyWithChildren => _friendlyWithChildren;
  bool get friendlyWithOtherPets => _friendlyWithOtherPets;
  bool get houseTrained => _houseTrained;
  int get walksPerDay => _walksPerDay;
  String get energyLevel => _energyLevel;
  String? get feedingSchedule => _feedingSchedule;
  bool get canBeLeftAlone => _canBeLeftAlone;

  final FireStoreService _fireStoreService = FireStoreService();
    final FirebaseStorage _storage = FirebaseStorage.instance;


  void setPetName(String name) {
    _petName = name;
    notifyListeners();
  }

  void setBreed(String breed) {
    _breed = breed;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setFriendlyWithChildren(bool value) {
    _friendlyWithChildren = value;
    notifyListeners();
  }

  void setFriendlyWithOtherPets(bool value) {
    _friendlyWithOtherPets = value;
    notifyListeners();
  }

  void setHouseTrained(bool value) {
    _houseTrained = value;
    notifyListeners();
  }

  void setWalksPerDay(int value) {
    _walksPerDay = value;
    notifyListeners();
  }

  void setEnergyLevel(String value) {
    _energyLevel = value;
    notifyListeners();
  }

  void setFeedingSchedule(String schedule) {
    _feedingSchedule = schedule;
    notifyListeners();
  }

  void setCanBeLeftAlone(bool value) {
    _canBeLeftAlone = value;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setPetweight(int weight) {
    _weight = weight;
    notifyListeners();
  }

  void setAboutPet(String aboutPet) {
    _aboutPet = aboutPet;
    notifyListeners();
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImageFile = File(pickedFile.path);
      notifyListeners();
      showSnackBar(context, 'Profile image picked successfully!');
    } else {
      showSnackBar(context, 'No profile image selected!');
    }
  }
   Future<void> registerPet(BuildContext context) async {
    setLoading(true);
    await Provider.of<OwnerDetailsGetterProvider>(context, listen: false)
        .loadUserProfile();
    var ownerEmail =
        Provider.of<OwnerDetailsGetterProvider>(context, listen: false).email;
    final selectedPetType =
        Provider.of<PetsProvider>(context, listen: false).selectedPetType;

    print('Owner Email: $ownerEmail');
    print('Selected Pet Type: $selectedPetType');

    if (_petName != null &&
        _breed != null &&
        _age != null &&
        _profileImageFile != null &&
        _gender != null) {
      try {
        // Check if the pet name is already registered
        bool isDuplicate =
            await _fireStoreService.isPetNameDuplicate(ownerEmail, _petName!);

        if (isDuplicate) {
          showSnackBar(context,
              "Pet name already exists. Please choose a different name.");
          setLoading(false);
          return;
        }

        // Save the pet details with a placeholder image URL
        await _fireStoreService.savePetDetails(
          ownerEmail: ownerEmail,
          petName: _petName!,
          breed: _breed!,
          age: _age!,
          gender: _gender!,
          imagePath: '', // Placeholder
          friendlyWithChildren: _friendlyWithChildren,
          friendlyWithOtherPets: _friendlyWithOtherPets,
          houseTrained: _houseTrained,
          walksPerDay: _walksPerDay,
          energyLevel: _energyLevel,
          feedingSchedule: _feedingSchedule ?? '',
          canBeLeftAlone: _canBeLeftAlone,
          selectedPetType: selectedPetType ?? '',
          aboutPet: _aboutPet ?? '',
          weight: _weight,
        );

        // Upload the image to Firebase Storage
        String filePath = 'pets_images/${ownerEmail}_${_petName}.jpg';
        UploadTask uploadTask =
            _storage.ref().child(filePath).putFile(_profileImageFile!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the Firestore document with the real image URL
        await _fireStoreService.updateProfileImage(
          ownerEmail: ownerEmail,
          petName: _petName!,
          imageUrl: imageUrl,
        );

        final petsDetailsProvider =
            Provider.of<PetsDetailsGetterProvider>(context, listen: false);
        await petsDetailsProvider.loadPets();

        showSnackBar(context, "Pet Registration Successful");
        navigateToOwnerDashboard(context);
      } catch (e) {
        showSnackBar(context, "Error! Something went wrong!");
        print(
            'Pet Name: $_petName, Breed: $_breed, Age: $_age, Gender: $_gender, Image Path: ${_image?.path}');

        print('Error registering pet: $e');
      } finally {
        setLoading(false);
      }
    } else {
      showSnackBar(context, "Please fill all the fields and upload an image");
      print('Please fill all the fields and upload an image');
      setLoading(false);
    }
  }

  void navigateToPetRegistration2(BuildContext context) {
    Navigator.pushNamed(context, '/petRegistration2');
  }

  void navigateToOwnerDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/ownerHomeScreen');
  }
}
