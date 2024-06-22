import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/auth_service.dart/owner_authservice.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:provider/provider.dart';

class VolunteerRegistrationProvider extends ChangeNotifier {
  String _volunteerName = '';
  String _volunteerEmail = '';
  String _volunteerPassword = '';
  String _volunteerPhoneNo = '';
  String _volunteerAge = '';
  String _volunteerOccupation = '';
  String _volunteerAboutMe = '';
  bool _prefersCat = false;
  bool _prefersDog = false;
  bool _prefersBird = false;
  bool _prefersRabbit = false;
  bool _prefersOthers = false;
  bool _providesHomeVisits = false;
  bool _providesDogWalking = false;
  bool _providesHouseSitting = false;
  bool _isVolunteerPasswordVisible = false;

  bool _isVolunteerLoggedIn = false;
  String _locationCity = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _volunteerRole = 'volunteer';
  final AuthService _authService = AuthService();
  final FireStoreServiceVolunteer _fireStoreService = FireStoreServiceVolunteer();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  bool get isVolunteerLoggedIn => _isVolunteerLoggedIn;
  String get volunteerName => _volunteerName;
  String get volunteerEmail => _volunteerEmail;
  String get volunteerPassword => _volunteerPassword;
  String get volunteerPhoneNo => _volunteerPhoneNo;
  String get volunteerAge => _volunteerAge;
  String get volunteerOccupation => _volunteerOccupation;
  String get volunteerAboutMe => _volunteerAboutMe;
  String get locationCity => _locationCity;
  bool get prefersCat => _prefersCat;
  bool get prefersDog => _prefersDog;
  bool get prefersBird => _prefersBird;
  bool get prefersRabbit => _prefersRabbit;
  bool get prefersOthers => _prefersOthers;
  bool get providesHomeVisits => _providesHomeVisits;
  bool get providesDogWalking => _providesDogWalking;
  bool get providesHouseSitting => _providesHouseSitting;
  bool get isPasswordVisible => _isVolunteerPasswordVisible;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setVolunteerName(String name) {
    _volunteerName = name;
    notifyListeners();
  }

  void setVolunteerEmail(String email) {
    _volunteerEmail = email;
    notifyListeners();
  }

  void setVolunteerPassword(String password) {
    _volunteerPassword = password;
    notifyListeners();
  }

  void setVolunteerPhoneNo(String phoneNo) {
    _volunteerPhoneNo = phoneNo;
    notifyListeners();
  }

  void setVolunteerAge(String age) {
    _volunteerAge = age;
    notifyListeners();
  }

  void setVolunteerAboutMe(String aboutMe) {
    _volunteerAboutMe = aboutMe;
    notifyListeners();
  }

  void setPrefersCat(bool value) {
    _prefersCat = value;
    notifyListeners();
  }

  void setPrefersDog(bool value) {
    _prefersDog = value;
    notifyListeners();
  }

  void setPrefersBird(bool value) {
    _prefersBird = value;
    notifyListeners();
  }

  void setPrefersRabbit(bool value) {
    _prefersRabbit = value;
    notifyListeners();
  }

  void setPrefersOthers(bool value) {
    _prefersOthers = value;
    notifyListeners();
  }

  void setProvidesHomeVisits(bool value) {
    _providesHomeVisits = value;
    notifyListeners();
  }

  void setProvidesDogWalking(bool value) {
    _providesDogWalking = value;
    notifyListeners();
  }

  void setProvidesHouseSitting(bool value) {
    _providesHouseSitting = value;
    notifyListeners();
  }

  void setVolunteerOccupation(String occupation) {
    _volunteerOccupation = occupation;
    notifyListeners();
  }

  void toggleVolunteerPasswordVisibility() {
    _isVolunteerPasswordVisible = !_isVolunteerPasswordVisible;
    notifyListeners();
  }

  void setLocationCity(String locationCity) {
    _locationCity = locationCity;
    notifyListeners();
  }

  Future<void> volunteerSignUp(BuildContext context) async {
    if (_volunteerName.isEmpty ||
        _volunteerEmail.isEmpty ||
        _volunteerPassword.isEmpty ||
        _volunteerPhoneNo.isEmpty ||
        _volunteerAge.isEmpty) {
      showSnackBar(context, "All fields are required!");
      print("All fields are required!");
      return;
    }

    if (_volunteerPassword.length < 8) {
      showSnackBar(context, "Password should be at least 8 characters");
      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_volunteerEmail)) {
      showSnackBar(context, "Email should be in correct format");
      print("Email should be in correct format!");
      return;
    }

    User? user = await _authService.signUp(_volunteerEmail, _volunteerPassword);

    if (user != null) {
      await _fireStoreService.saveVolunteerDetails(
          userId: user.uid,
          name: volunteerName,
          email: volunteerEmail,
          phoneNo: volunteerPhoneNo,
          age: volunteerAge,
          occupation: volunteerOccupation,
          aboutMe: volunteerAboutMe,
          prefersCat: prefersCat,
          prefersDog: prefersDog,
          prefersBird: prefersBird,
          prefersRabbit: prefersRabbit,
          prefersOthers: prefersOthers,
          providesHomeVisits: providesHomeVisits,
          providesDogWalking: providesDogWalking,
          providesHouseSitting: providesHouseSitting,
          role: _volunteerRole,
          locationCity: _locationCity);

      await _prefsService.setBool('isVolunteerLoggedIn', true);
      _isVolunteerLoggedIn = true;
      notifyListeners();
      showSnackBar(context, "Volunteer Signup Successful");
      Provider.of<VolunteerDetailsGetterProvider>(context, listen: false)
          .loadVolunteerDetails();

      navigateToVolunteerDashboard(context);
      print('Volunteer signed up and details saved');
    } else {
      print("Sign Up Failed!");
      showSnackBar(context, "SignUp Failed!");
    }
  }

  Future<void> checkVolunteerLoginStatus() async {
    _isVolunteerLoggedIn = _prefsService.getBool('isVolunteerLoggedIn');
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _prefsService.setBool('isVolunteerLoggedIn', false);
    _isVolunteerLoggedIn = false;
    notifyListeners();
    navigateToSplashScreen(context);
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  void navigateToVolunteerLogin(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerLogin');
  }

  void navigateToVolunteerReg(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerReg');
  }

  void navigateToVolunteerReg2(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerRegister2');
  }

  void navigateToVolunteerDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerHomeScreen');
  }
}
