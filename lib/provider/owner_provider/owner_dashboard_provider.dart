import 'package:flutter/material.dart';

class OwnerDashboardProvider with ChangeNotifier {
  int _selectedPetIndex = 0;

  int get selectedPetIndex => _selectedPetIndex;

  void selectPetIndex(int index) {
    _selectedPetIndex = index;
    notifyListeners();
  }
}
