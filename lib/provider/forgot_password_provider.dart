import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/services/auth_service/owner_authservice.dart';
import 'package:toastification/toastification.dart';

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
      ToastNotification.showToast(
        context,
        message: 'Email is required',
        type: ToastType.error,
      );
      print('Email is required');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.forgotPassword(_email);

      ToastNotification.showToast(
        context,
        message: 'Password reset email sent to $_email',
        type: ToastType.positive,
      );
      print('Password reset email sent to $_email');
    } catch (error) {
      ToastNotification.showToast(context,
          message: "Error resetting password : $error", type: ToastType.error);
      print('Error resetting password: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
