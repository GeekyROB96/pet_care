import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/owner_provider/get_ownerData_provider.dart';
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

          ToastNotification.showToast(context,
          message: "All fields are required", type: ToastType.normal);
      print("All fields are required!");
      return;
    }

    if (_password.length < 8) {
      ToastNotification.showToast(context,
          message: "Password should be atleast 8 characters", type: ToastType.normal);
      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_email)) {
      ToastNotification.showToast(context,
          message: "Email should be in correct format", type: ToastType.positive);
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

        setName(_name);
        setEmail(_email);
        _isOwnerLoggedIn = true;
        await _prefsService.setBool('isLoggedIn', true);

ToastNotification.showToast(context,
          message: "Sign up success ", type: ToastType.positive);
        Provider.of<OwnerDetailsGetterProvider>(context, listen: false)
            .loadUserProfile();

        navigateToPets(context);

        print('Owner signed up and details saved');
      }
    } catch (e) {
      print('Error signing up: $e');
      ToastNotification.showToast(context,
          message: "Signup Failed $e", type: ToastType.error);
    } finally {
      setLoading(false); 
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
    _isOwnerLoggedIn = _prefsService.getBool('isLoggedIn') ;
    notifyListeners();
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }
}
