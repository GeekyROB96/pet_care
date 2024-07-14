import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/owner_provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/services/auth_service/owner_authservice.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:provider/provider.dart';

class OwnerLoginProvider extends ChangeNotifier {
  String _ownerEmail = '';
  String _ownerPassword = '';
  bool _isOwnerPasswordVisible = false;
  bool _isOwnerLoggedIn = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get ownerEmail => _ownerEmail;
  String get ownerPassword => _ownerPassword;
  bool get isOwnerPasswordVisible => _isOwnerPasswordVisible;
  bool get isOwnerLoggedIn => _isOwnerLoggedIn;

  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  void setOwnerEmail(String email) {
    _ownerEmail = email;
    notifyListeners();
  }

  void setOwnerPassword(String password) {
    _ownerPassword = password;
    notifyListeners();
  }

  void toggleOwnerPasswordVisibility() {
    _isOwnerPasswordVisible = !_isOwnerPasswordVisible;
    notifyListeners();
  }

  Future<void> ownerLogin(BuildContext context) async {
    if (_isLoading) return; // Return if already loading

    setLoading(true);

    if (_ownerEmail.isEmpty || _ownerPassword.isEmpty) {
      setLoading(false);
      ToastNotification.showToast(context,
          message: "All fields are required", type: ToastType.error);
      print("All fields are required!");
      return;
    }

    if (_ownerPassword.length < 8) {
      setLoading(false);

      ToastNotification.showToast(context,
          message: "Password must be at least 8 characters", type: ToastType.normal);
      print("Password should be at least 8 characters");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_ownerEmail)) {
      setLoading(false);
      ToastNotification.showToast(context,
          message: "Email should be in correct format", type: ToastType.normal);
      print("Email should be in correct format!");
      return;
    }

    try {
      User? user = await _authService.signIn(_ownerEmail, _ownerPassword);

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc('pet_owners')
            .collection('pet_owners')
            .doc(user.uid)
            .get();

        print(userDoc);

        if (userDoc.exists && userDoc['role'] == 'owner') {
          await _prefsService.setBool('isOwnerLoggedIn', true);
          _isOwnerLoggedIn = true;
          notifyListeners();
          print("Shared Value is $_isOwnerLoggedIn");
          print('User signed in successfully');

          final petsDetailsProvider =
              Provider.of<PetsDetailsGetterProvider>(context, listen: false);
          await petsDetailsProvider.loadPets();

          Provider.of<OwnerDetailsGetterProvider>(context, listen: false)
              .loadUserProfile();

          print('email at sign in is : ' + userDoc['email']);

          navigateToOwnerDashboard(context);
ToastNotification.showToast(context,
          message: "Sign in successful", type: ToastType.positive);  
                  print("Shared Value is $_isOwnerLoggedIn");
        } else {
          ToastNotification.showToast(context,
          message: "You are not authorized to log in as owner", type: ToastType.error);
          await FirebaseAuth.instance.signOut();
        }
      } else {
        ToastNotification.showToast(context,
          message: "Login Failed ", type: ToastType.error);
        print('Login failed');
      }
    } catch (e) {
      print("Error logging in: $e");
      ToastNotification.showToast(context,
          message: "Error logging in $e", type: ToastType.error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> ownerLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _prefsService.setBool('isOwnerLoggedIn', false);
    _isOwnerLoggedIn = false;
    notifyListeners();
    navigateToSplashScreen(context);
  }

  Future<void> checkOwnerLoginStatus() async {
    _isOwnerLoggedIn = _prefsService.getBool('isOwnerLoggedIn');
    notifyListeners();
  }

  void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgotPassword');
  }

  void navigateToOwnerDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/ownerHomeScreen');
  }

  void navigateToSplashScreen(BuildContext context) {
    Navigator.pushNamed(context, '/splashScreen');
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
