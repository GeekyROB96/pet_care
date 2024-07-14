import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/volunteer_provider/volunteer_login_provider.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:provider/provider.dart';

class VolunteerDetailsGetterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FireStoreServiceVolunteer _fireStoreService =
      FireStoreServiceVolunteer();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String currentuid = '';
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

  bool _providesHomeVisits = false;
  bool _providesHouseSitting = false;
  int? _providesHomeVisitsPrice;
  int? _providesHouseSittingPrice;

  bool _preferCat = false;
  bool _preferDog = false;
  bool _preferBird = false;
  bool _prefersRabbit = false;
  bool _prefersOthers = false;
  bool _provideDogWalking = false;
  String? _locationCity;

  Map<String, dynamic>? volunteerData;

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
  bool get providesHomeVisits => _providesHomeVisits;
  bool get providesHouseSitting => _providesHouseSitting;

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
        setName(_name);
        _email = volunteerData?['email'] ?? '';
        _phoneNo = volunteerData?['phoneNo'] ?? '';
        _imageUrl = volunteerData?['profileImageUrl'];
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


          if (volunteerData?['Address'] != null && volunteerData?['Address'] is List && volunteerData?['Address'].isNotEmpty) {
            final address = volunteerData?['Address'][0];
            _area_apartment_road = address['area_apartment_road'];
            _city = address['city'];
            _coordinates = address['coordinates'];
            _description_directions = address['description_directions'];
            _main = address['main'];
            _pincode = address['pincode'];
            _state = address['state'];
          }

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

      ToastNotification.showToast(context,
          message: "Profile Image picked Successfuly.", type: ToastType.positive);
    } else {
  ToastNotification.showToast(context,
          message: "No Image Selected!", type: ToastType.normal);    }
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
            ToastNotification.showToast(context,
          message: "You have not opted for Home Visits Service.", type: ToastType.normal);
          return;
        }

        if (updatedVolunteerData?['providesHouseSitting'] == false &&
            _providesHouseSittingPrice != null) {
           ToastNotification.showToast(context,
          message: "You have not opted for House  Sitting Service.", type: ToastType.normal);
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
          locationCity: _locationCity,
        );

 ToastNotification.showToast(context,
          message: "Profile details updated Succesfully!.", type: ToastType.positive);  
              } catch (e) {
 ToastNotification.showToast(context,
          message: "Error Saving Profile $e", type: ToastType.error);
                  print("Error Saving Profile: $e");
      }
    } else {

       ToastNotification.showToast(context,
          message: "No User Logged In", type: ToastType.error);
    }
  }

  Future<void> volunteerLogout(BuildContext context) async {
    try {
      await Provider.of<VolunteerLoginProvider>(context, listen: false)
          .volunteerLogout(context);
           ToastNotification.showToast(context,
          message: "Logout Successful", type: ToastType.normal);
      clearData();
    } catch (e) {
       ToastNotification.showToast(context,
          message: "Error Logging Out $e", type: ToastType.error);
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
    _uid = '';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
