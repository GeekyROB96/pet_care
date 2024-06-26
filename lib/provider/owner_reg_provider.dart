import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/services/auth_service/owner_authservice.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:provider/provider.dart';

class OwnerRegistrationProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNo = '';
  String _age = '';
  String _occupation = '';
  bool _isPasswordVisible = false;
  bool _isOwnerLoggedIn = false;
  String _locationCity = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _role = 'owner';
  String get locationCity => _locationCity;

  final AuthService _authService = AuthService();
  final FirestoreServiceOwner _fireStoreService = FirestoreServiceOwner();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get phoneNo => _phoneNo;
  String get age => _age;
  String get occupation => _occupation;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isOwnerLoggedIn => _isOwnerLoggedIn;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

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

  void setLocationCity(String locationCity) {
    _locationCity = locationCity;
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
      showSnackBar(context, 'Password should be at least 8 characters!');
      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_email)) {
      showSnackBar(context, "Email should be in correct format!");
      print("Email should be in correct format!");
      return;
    }

    setLoading(true); // Set loading to true

    try {
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
            locationCity: _locationCity);

        // Update local state after successful signup
        setName(_name);
        setEmail(_email);
        _isOwnerLoggedIn = true;
        await _prefsService.setBool('isLoggedIn', true);

        showSnackBar(context, "Owner signed up and details saved");

        // Load user profile details (if needed)
        Provider.of<OwnerDetailsGetterProvider>(context, listen: false)
            .loadUserProfile();

        // Navigate to the next screen after successful signup
        navigateToPets(context);

        print('Owner signed up and details saved');
      }
    } catch (e) {
      print('Error signing up: $e');
      showSnackBar(context, 'Failed to sign up. Please try again later.');
    } finally {
      setLoading(false); // Set loading to false in any case
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
    _isOwnerLoggedIn = _prefsService.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }
}
