import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_provider/owner_login_provider.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service/pet_register.dart';

class OwnerDetailsGetterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServiceOwner _fireStoreService = FirestoreServiceOwner();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final PetFireStoreService _petFireStoreService =
      PetFireStoreService(); // Instance of PetFireStoreService

  String _name = '';
  String _email = '';
  String _phoneNo = '';
  String? _profileImageUrl;
  String? _age;
  String? _occupation;
  String? _imageUrl;
  String? _uid;

  String? _area_apartment_road;
  String? _city;
  String? _coordinates;
  String? _description_directions;
  String? _main;
  String? _pincode;
  String? _state;

  String? get area_apartment_road => _area_apartment_road;
  String? get city => _city;
  String? get coordinates => _coordinates;
  String? get description_directions => _description_directions;
  String? get main => _main;
  String? get pincode => _pincode;
  String? get state => _state;

  bool _isDataLoaded = false;
  File? _profileImageFile;
  String? _locationCity;
  var _address;

  bool get isDataLoaded => _isDataLoaded;
  String get name => _name;
  String get email => _email;
  String get phoneNo => _phoneNo;
  String? get profileImageUrl => _profileImageUrl;
  String? get age => _age;
  String? get occupation => _occupation;
  String? get imageUrl => _imageUrl;

  File? get profileImageFile => _profileImageFile;
  String? get locationCity => _locationCity;

  String? get uid => _uid;

  OwnerDetailsGetterProvider() {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        Map<String, dynamic>? userDetails =
            await _fireStoreService.getOwnerDetails(user.uid);
        print(userDetails);
        if (userDetails != null) {
          _name = userDetails['name'];
          _email = userDetails['email'];
          _phoneNo = userDetails['phoneNo'];
          _profileImageUrl = userDetails['profileImageUrl'];
          _age = userDetails['age'];
          _occupation = userDetails['occupation'];
          _locationCity = userDetails['locationCity'];
          _isDataLoaded = true;
          _uid = userDetails['uid'];
          _address = userDetails['Address'];
          if (userDetails['Address'] != null &&
              userDetails['Address'] is List &&
              userDetails['Address'].isNotEmpty) {
            final address = userDetails['Address'][0];
            _area_apartment_road = address['area_apartment_road'];
            _city = address['city'];
            _coordinates = address['coordinates'];
            _description_directions = address['description_directions'];
            _main = address['main'];
            _pincode = address['pincode'];
            _state = address['state'];
          }

          // Set data loaded to true
          notifyListeners();
        }
      } catch (e) {
        print("Error loading user profile: $e");
      }
    }
  }

  void clearData() {
    _name = '';
    _email = '';
    _phoneNo = '';
    _profileImageUrl = null;
    _age = null;
    _occupation = null;
    _isDataLoaded = false;
    _locationCity = '';
    notifyListeners();
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImageFile = File(pickedFile.path);
      notifyListeners();

      ToastNotification.showToast(context,
          message: "Profile image picked successfully!",
          type: ToastType.positive);
    } else {
      ToastNotification.showToast(context,
          message: "No profile image selected!", type: ToastType.normal);
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        if (_profileImageFile != null) {
          String filePath = 'owner/profile_images/${user.uid}.jpg';
          UploadTask uploadTask =
              _storage.ref().child(filePath).putFile(_profileImageFile!);
          TaskSnapshot taskSnapshot = await uploadTask;
          _imageUrl = await taskSnapshot.ref.getDownloadURL();
          await _fireStoreService.updateProfileImage(
              userId: user.uid, imageUrl: _imageUrl!);
        }

        await _fireStoreService.saveUserDetails(
          userId: user.uid,
          name: _name,
          email: _email,
          phoneNo: _phoneNo,
          age: _age ?? '',
          occupation: _occupation ?? '',
          locationCity: _locationCity ?? '',
          profileImageUrl: _imageUrl,
          role: 'owner',
        );

        ToastNotification.showToast(context,
            message: "Profile details saved successfully!",
            type: ToastType.positive);
      } catch (e) {
        ToastNotification.showToast(context,
            message: "Error Saving profile  : $e!", type: ToastType.error);
        print("Error saving profile: $e");
      }
    } else {
      ToastNotification.showToast(context,
          message: "No user logged In", type: ToastType.normal);
    }
  }

  Future<void> ownerLogout(BuildContext context) async {
    try {
      await Provider.of<OwnerLoginProvider>(context, listen: false)
          .ownerLogout(context);
      Provider.of<PetsDetailsGetterProvider>(context, listen: false)
          .clearData();
      clearData();
      ToastNotification.showToast(context,
          message: "User logged out successfully.", type: ToastType.normal);
      Navigator.pushNamed(context, '/splashScreen');
    } catch (e) {
      ToastNotification.showToast(context,
          message: "Error logging Out $e", type: ToastType.error);
      print("Error logging out: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getPets() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        List<Map<String, dynamic>> pets =
            await _petFireStoreService.getPets(user.email!);
        return pets;
      } catch (e) {
        print("Error fetching pets: $e");
        return [];
      }
    } else {
      print("User not logged in.");
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
