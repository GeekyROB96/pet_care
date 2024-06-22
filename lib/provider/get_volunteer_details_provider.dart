import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/volunteer_login_provider.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:provider/provider.dart';

class VolunteerDetailsGetterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FireStoreServiceVolunteer _fireStoreService =
      FireStoreServiceVolunteer();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _uid = '';
  String _name = '';
  String _email = '';
  String _phoneNo = '';
  String? _profileImageUrl;
  File? _profileImageFile;
  bool _isDataLoaded = false;
  String _aboutMe = '';
  String? _imageUrl;
  String? _age;
  String? _occupation;
  int? _providesHomeVisitsPrice;
  int? _providesHouseSittingPrice;

  bool _preferCat = false;
  bool _preferDog = false;
  bool _preferBird = false;
  bool _prefersRabbit = false;
  bool _prefersOthers = false;
  bool _providesHomeVisits = false;
  bool _provideDogWalking = false;
  bool _providesHouseSitting = false;
  String? _locationCity;

  Map<String, dynamic>? volunteerData;

  String get uid => _uid;
  bool get isDataLoaded => _isDataLoaded;
  String get name => _name;
  String get email => _email;
  String get phoneNo => _phoneNo;
  String? get profileImageUrl => _profileImageUrl;
  File? get profileImageFile => _profileImageFile;
  String? get aboutMe => _aboutMe;
  String? get imageUrl => _imageUrl;
  String? get age => _age;
  String? get occupation => _occupation;
  int? get providesHomeVisitsPrice => _providesHomeVisitsPrice;
  int? get providesHouseSittingPrice => _providesHouseSittingPrice;
  String? get locationCity => _locationCity;

  VolunteerDetailsGetterProvider() {
    loadVolunteerDetails();
  }

  Future<void> loadVolunteerDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final volunteerData =
            await _fireStoreService.getVolunteerDetails(user.uid);
        _name = volunteerData?['name'] ?? '';
        _email = volunteerData?['email'] ?? '';
        _phoneNo = volunteerData?['phoneNo'] ?? '';
        _profileImageUrl = volunteerData?['profileImageUrl'];
        _aboutMe = volunteerData?['aboutMe'];
        _age = volunteerData?['age'];
        _occupation = volunteerData?['occupation'];

        _preferCat = volunteerData?['prefersCat'] ?? false;
        _preferDog = volunteerData?['prefersDog'] ?? false;
        _preferBird = volunteerData?['prefersBird'] ?? false;
        _prefersRabbit = volunteerData?['prefersRabbit'] ?? false;
        _prefersOthers = volunteerData?['prefersOthers'] ?? false;
        _providesHomeVisits = volunteerData?['providesHomeVisits'] ?? false;
        _provideDogWalking = volunteerData?['providesDogWalking'] ?? false;
        _providesHouseSitting = volunteerData?['providesHouseSitting'] ?? false;

        _providesHomeVisitsPrice = volunteerData?['providesHomeVisitsPrice'];
        _providesHouseSittingPrice =
            volunteerData?['providesHouseSittingPrice'];

        _locationCity = volunteerData?['locationCity'];
        _uid = volunteerData?['uid'];

        _isDataLoaded = true;
        notifyListeners();
      } catch (e) {
        print("Error loading volunteer details: $e");
      }
    } else {
      print("No user logged in.");
    }
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setprovideHomeSVisitsPrice(int providesHomeVisitsPrice) {
    _providesHomeVisitsPrice = providesHomeVisitsPrice;
    notifyListeners();
    print(providesHomeVisitsPrice);
  }

  void setprovideHouseSitting(int providesHouseSittingPrice) {
    _providesHouseSittingPrice = providesHouseSittingPrice;
    notifyListeners();
    print(providesHouseSittingPrice);
  }

  void setPhoneNo(String phoneNo) {
    _phoneNo = phoneNo;
    notifyListeners();
  }

  void setAboutMe(String aboutMe) {
    _aboutMe = aboutMe;
    notifyListeners();
  }

  bool checkHomeVisits() {
    return volunteerData?['providesHomeVisits'] ?? false;
  }

  bool checkHouseSitting() {
    return volunteerData?['providesHouseSitting'] ?? false;
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImageFile = File(pickedFile.path);
      notifyListeners();
      showSnackBar(context, 'Profile Image picked successfully!');
    } else {
      showSnackBar(context, "No profile image selected!");
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Inside saveProfile method
        if (_profileImageFile != null) {
          String filePath = 'volunteer/profile_images/${user.uid}.jpg';
          UploadTask uploadTask =
              _storage.ref().child(filePath).putFile(_profileImageFile!);
          TaskSnapshot taskSnapshot = await uploadTask;
          _imageUrl = await taskSnapshot.ref.getDownloadURL();

          // Update profile image URL in Firestore
          await _fireStoreService.updateVolunteerProfileImage(
              userId: user.uid, imageUrl: _imageUrl!);
        }

// Fetch updated volunteer details after profile image upload
        final updatedVolunteerData =
            await _fireStoreService.getVolunteerDetails(user.uid);
// Ensure to update local variables with updated data if needed

// Perform save operation
        if (updatedVolunteerData?['providesHomeVisits'] == false &&
            _providesHomeVisitsPrice != null) {
          showSnackBar(
              context, 'You have not opted for HomeVisits Service option');
          return;
        }

        if (updatedVolunteerData?['providesHouseSitting'] == false &&
            _providesHouseSittingPrice != null) {
          showSnackBar(
              context, 'You have not opted for House Sitting Service option');
          return;
        }

        await _fireStoreService.saveVolunteerDetails(
            userId: user.uid,
            name: _name,
            email: _email,
            phoneNo: _phoneNo,
            age: _age ?? '',
            occupation: _occupation ?? '',
            aboutMe: _aboutMe,
            prefersCat: _preferCat,
            prefersDog: _preferDog,
            prefersBird: _preferBird,
            prefersRabbit: _prefersRabbit,
            prefersOthers: _prefersOthers,
            providesHomeVisits: _providesHomeVisits,
            providesDogWalking: _provideDogWalking,
            providesHouseSitting: _providesHouseSitting,
            role: 'volunteer',
            profileImageUrl: _imageUrl,
            providesHomeVisitsPrice: _providesHomeVisitsPrice,
            providesHouseSittingPrice: _providesHouseSittingPrice,
            locationCity: _locationCity);

        showSnackBar(context, "Profile details saved successfully!");
      } catch (e) {
        showSnackBar(context, e.toString());
        print("Error Saving Profile: $e");
      }
    } else {
      showSnackBar(context, "No user logged in");
    }
  }

  Future<void> volunteerLogout(BuildContext context) async {
    try {
      await Provider.of<VolunteerLoginProvider>(context, listen: false)
          .volunteerLogout(context);
      showSnackBar(context, "Logout Successful!");
      clearData();
    } catch (e) {
      print("Error logging out $e");
      showSnackBar(context, "Error logging out $e");
    }
  }

  void clearData() {
    _name = '';
    _email = '';
    _phoneNo = '';
    _aboutMe = '';
    _imageUrl = '';
    _providesHomeVisits = false;
    _providesHouseSitting = false;
    _providesHomeVisitsPrice = null;
    _providesHouseSittingPrice = null;
    _locationCity = '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
