import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_login_provider.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:provider/provider.dart';

class OwnerEditProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServiceOwner _fireStoreService = FirestoreServiceOwner();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _name = '';
  String _email = '';
  String _phoneNo = '';
  String? _profileImageUrl;
  File? _profileImageFile;
  String? _age;
  String? _occupation;

  String get name => _name;
  String get email => _email;
  String get phoneNo => _phoneNo;
  String? get profileImageUrl => _profileImageUrl;
  File? get profileImageFile => _profileImageFile;
  String? get age => _age;
  String? get occupation => _occupation;

  OwnerEditProfileProvider() {
    loadUserProfile(); // Load user profile details when initialized
  }

  // Method to load user profile details
  Future<void> loadUserProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        Map<String, dynamic>? userDetails =
            await _fireStoreService.getOwnerDetails(user.uid);

        if (userDetails != null) {
          _name =
              userDetails['name'] ?? ''; // Use ?? '' to provide default value
          _email = userDetails['email'] ?? '';
          _phoneNo = userDetails['phoneNo'] ?? '';
          _profileImageUrl = userDetails['profileImageUrl'];
          _age = userDetails['age'];
          _occupation = userDetails['occupation'];

          notifyListeners();
          print("User profile loaded successfully.");
        } else {
          print("No user details found.");
        }
      } catch (e) {
        print("Error loading user profile: $e");
      }
    }
  }

  void setPhoneNo(String phoneNo) {
    _phoneNo = phoneNo;
    notifyListeners();
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImageFile = File(pickedFile.path);
      notifyListeners();
      showSnackBar(context, 'Profile image picked successfully!');
      print("Profile image picked successfully.");
    } else {
      showSnackBar(context, 'No profile image selected!');
      print("No profile image selected.");
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        if (_profileImageFile != null) {
          String filePath = 'profile_images/${user.uid}.jpg';

          UploadTask uploadTask =
              _storage.ref().child(filePath).putFile(_profileImageFile!);

          TaskSnapshot taskSnapshot = await uploadTask;

          _profileImageUrl = await taskSnapshot.ref.getDownloadURL();

          await _fireStoreService.updateProfileImage(
              userId: user.uid, imageUrl: _profileImageUrl!);
          showSnackBar(
              context, "Profile image uploaded and URL updated successfully");
          print("Profile image uploaded and URL updated successfully.");
        }

        await _fireStoreService.saveUserDetails(
            userId: user.uid,
            name: _name,
            email: _email,
            phoneNo: _phoneNo,
            age:
                _age!, //added age, occupation to prevent it from being overwritten
            occupation: _occupation!,
            role: 'owner');
        showSnackBar(context, "Profile details saved successfully!");
        print("Profile details saved successfully.");
      } catch (e) {
        showSnackBar(context, "Error saving profile");
        print("Error saving profile: $e");
      }
    } else {
      showSnackBar(context, "No user logged in");
      print("No user logged in.");
    }
  }

  Future<void> ownerLogout(BuildContext context) async {
    try {
      await Provider.of<OwnerLoginProvider>(context, listen: false)
          .ownerLogout(context);

      Provider.of<PetsDetailsGetterProvider>(context, listen: false)
          .clearData();
      Provider.of<OwnerDetailsGetterProvider>(context, listen: false)
          .clearData();
      showSnackBar(context, "User logged out successfully.");
      print("User logged out successfully.");
    } catch (e) {
      showSnackBar(context, "Error logging out");
      print("Error logging out: $e");
    }
  }

  setName(String value) {}
}
