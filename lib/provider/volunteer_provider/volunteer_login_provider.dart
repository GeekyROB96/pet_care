import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/volunteer_provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/auth_service/owner_authservice.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:provider/provider.dart';

class VolunteerLoginProvider extends ChangeNotifier {
  String _volunteerEmail = '';
  String _volunteerPassword = '';
  bool _isVolunteerPasswordVisible = false;
  bool _isVolunteerLoggedIn = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get volunteerEmail => _volunteerEmail;
  String get volunteerPassword => _volunteerPassword;
  bool get isVolunteerPasswordVisible => _isVolunteerPasswordVisible;
  bool get isVolunteerLoggedIn => _isVolunteerLoggedIn;

  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  void setVolunteerEmail(String email) {
    _volunteerEmail = email;
    notifyListeners();
  }

  void setVolunteerPassword(String password) {
    _volunteerPassword = password;
    notifyListeners();
  }

  void toggleVolunteerPasswordVisibility() {
    _isVolunteerPasswordVisible = !_isVolunteerPasswordVisible;
    notifyListeners();
  }

  Future<void> volunteerLogin(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    //await Future.delayed(Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    if (_volunteerEmail.isEmpty || _volunteerPassword.isEmpty) {
ToastNotification.showToast(context,
          message: "All fields required", type: ToastType.normal);  
              print("All fields are required!");
      return;
    }

    if (_volunteerPassword.length < 8) {
ToastNotification.showToast(context,
          message: "password should atleast be 8 characters", type: ToastType.normal);      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_volunteerEmail)) {
ToastNotification.showToast(context,
          message: "Email should be in correct format", type: ToastType.normal);      print("Email should be in correct format!");
      return;
    }
    setLoading(true);
    User? user = await _authService.signIn(_volunteerEmail, _volunteerPassword);

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc('volunteers')
          .collection('volunteers')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc['role'] == 'volunteer') {
        await _prefsService.setBool('isVolunteerLoggedIn', true);
        _isVolunteerLoggedIn = true;
        notifyListeners();
        print("Shared Value is $_isVolunteerLoggedIn");
        Provider.of<VolunteerDetailsGetterProvider>(context, listen: false)
            .loadVolunteerDetails();
        navigateToVolunteerDashboard(context);
ToastNotification.showToast(context,
          message: "Signin Successful", type: ToastType.positive);   
               print('User signed in successfully');
      } else {
       ToastNotification.showToast(context,
          message: "You are not authorized to log in as volunteer", type: ToastType.normal);
        print('You are not authorized to log in as a volunteer');
        await FirebaseAuth.instance.signOut();
      }
    } else {
ToastNotification.showToast(context,
          message: "Login failed ", type: ToastType.error); 
               print('Login failed');
    }
  }

  Future<void> volunteerLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _prefsService.setBool('isVolunteerLoggedIn', false);
    _isVolunteerLoggedIn = false;
    notifyListeners();
    navigateToSplashScreen(context);
  }

  Future<void> checkVolunteerLoginStatus() async {
    _isVolunteerLoggedIn = _prefsService.getBool('isVolunteerLoggedIn');
    notifyListeners();
  }

  void navigateToVolunteerReg(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerRegister');
  }

  void navigateToVolunteerDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/volunteerHomeScreen');
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
