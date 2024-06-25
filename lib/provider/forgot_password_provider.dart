import 'package:flutter/material.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/services/auth_service/owner_authservice.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _email = '';
  bool _isLoading = false;

  String get email => _email;
  bool get isLoading => _isLoading;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    if (_email.isEmpty) {
      showSnackBar(context, 'Email is Required');
      print('Email is required');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.forgotPassword(_email);
      showSnackBar(context, 'Password reset email sent to $_email');
      print('Password reset email sent to $_email');
    } catch (error) {
      showSnackBar(context, 'Error resetting password: $error');
      print('Error resetting password: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
