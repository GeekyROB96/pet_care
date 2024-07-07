import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_login_provider.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:provider/provider.dart';

class OwnerEditProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServiceOwner _fireStoreService = FirestoreServiceOwner();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _uid = '';
  String _name = '';
  String _email = '';
  String _phoneNo = '';
  String? _profileImageUrl;
  File? _profileImageFile;
  String? _age;
  String? _occupation;

  String? _area_apartment_road;
  String? _city;
  String? _coordinates;
  String? _description_directions;
  String? _main;
  String? _pincode;
  String? _state;

  String get name => _name;
  String get email => _email;
  String get phoneNo => _phoneNo;
  String? get profileImageUrl => _profileImageUrl;
  File? get profileImageFile => _profileImageFile;
  String? get age => _age;
  String? get occupation => _occupation;
  String? get uid => _uid;

  String? get area_apartment_road => _area_apartment_road;
  String? get city => _city;
  String? get coordinates => _coordinates;
  String? get description_directions => _description_directions;
  String? get main => _main;
  String? get pincode => _pincode;
  String? get state => _state;

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
          _uid = userDetails['uid'];
          _area_apartment_road = userDetails['area_apartment_road'];
          _city = userDetails['city'];
          _coordinates = userDetails['coordinates'];
          _description_directions = userDetails['description_directions'];
          _main = userDetails['main'];
          _pincode = userDetails['pincode'];
          _state = userDetails['state'];



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
      ToastNotification.showToast(context,
          message: "Profile Image picked successfully",
          type: ToastType.positive);
      print("Profile image picked successfully.");
    } else {
      ToastNotification.showToast(context,
          message: "No profile image selected", type: ToastType.normal);
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
          ToastNotification.showToast(context,
              message: "Profile image uploaded and URL updated successfully.",
              type: ToastType.positive);
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
          role: 'owner',
        );

        ToastNotification.showToast(context,
            message: "Profile details saved successfully",
            type: ToastType.positive);
        print("Profile details saved successfully.");
      } catch (e) {
        ToastNotification.showToast(context,
            message: "Error Saving Profile $e", type: ToastType.error);
        print("Error saving profile: $e");
      }
    } else {
      ToastNotification.showToast(context,
          message: "No User logged In.", type: ToastType.error);
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
      ToastNotification.showToast(context,
          message: "Logout Successfull", type: ToastType.normal);
      print("User logged out successfully.");
    } catch (e) {
      ToastNotification.showToast(context,
          message: "Error logging Out $e", type: ToastType.error);
      print("Error logging out: $e");
    }
  }

  setName(String value) {}
}
