import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/services/auth_service.dart/owner_authservice.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/shared_pref_service.dart';

class OwnerRegistrationProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNo = '';
  String _age = '';
  String _occupation = '';
  bool _isPasswordVisible = false;
  bool _isOwnerLoggedIn = false;

  final String _role = 'owner';

  final AuthService _authService = AuthService();
  final FireStoreService _fireStoreService = FireStoreService();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get phoneNo => _phoneNo;
  String get age => _age;
  String get occupation => _occupation;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isOwnerLoggedIn => _isOwnerLoggedIn;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setPhoneNo(String phoneNo) {
    _phoneNo = phoneNo;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  void setOccupation(String occupation) {
    _occupation = occupation;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    if (_name.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _phoneNo.isEmpty ||
        _age.isEmpty) {
      showSnackBar(context, 'All fields are required!');
      print("All fields are required!");
      return;
    }

    if (_password.length < 8) {
      showSnackBar(context, 'Password should be atleast 8 characters!');
      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_email)) {
      showSnackBar(context, "Email should be in correct format!");
      print("Email should be in correct format!");
      return;
    }

    User? user = await _authService.signUp(_email, _password);

    if (user != null) {
      await _fireStoreService.saveUserDetails(
        userId: user.uid,
        name: name,
        email: email,
        phoneNo: phoneNo,
        age: age,
        occupation: occupation,
        role: _role,
      );
      setName(_name);
      setEmail(_email);

      await _prefsService.setBool('isLoggedIn', true);
      _isOwnerLoggedIn = true;

      showSnackBar(context, "Owner signed up and details saved");
      navigateToPets(context);

      print('Owner signed up and details saved');
    }
  }

  void navigateToOwnerLogin(BuildContext context) {
    Navigator.pushNamed(context, '/ownerLogin');
  }

  void navigateToOwnerDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/ownerHomeScreen');
  }

  void navigateToPets(BuildContext context) {
    Navigator.pushNamed(context, '/pets');
  }

  Future<void> checkOwnerLoginStatus() async {
    _isOwnerLoggedIn = _prefsService.getBool('isLoggedIn');
    notifyListeners();
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }
}
