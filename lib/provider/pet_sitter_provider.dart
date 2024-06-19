import 'dart:convert'; // Import for jsonEncode

import 'package:flutter/material.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

class PetSitterProvider extends ChangeNotifier {
  final FireStoreService _fireStoreService = FireStoreService();
  List<Map<String, dynamic>> _volunteers = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get volunteers => _volunteers;
  bool get isLoading => _isLoading;

  Future<void> fetchVolunteers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _volunteers = await _fireStoreService.getAllVolunteers();
      _logLargeData(_volunteers);
      notifyListeners();
    } catch (e) {
      print("Error fetching volunteers: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sortByPriceAsc() async {
    _isLoading = true;
    notifyListeners();
    try {
      _volunteers
          .sort((a, b) => (a['minPrice'] ?? 0).compareTo(b['minPrice'] ?? 0));
      notifyListeners();
      _logLargeData(_volunteers);
    } catch (e) {
      print("Error sorting volunteers: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sortByPriceDsc() async {
    _isLoading = true;
    notifyListeners();
    try {
      _volunteers
          .sort((a, b) => (b['minPrice'] ?? 0).compareTo(a['minPrice'] ?? 0));
      notifyListeners();
      _logLargeData(_volunteers);
    } catch (e) {
      print("Error sorting volunteers: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void _logLargeData(List<Map<String, dynamic>> data) {
    const int chunkSize = 1000; // Adjust the size according to your needs
    final dataStr = jsonEncode(data);
    for (int i = 0; i < dataStr.length; i += chunkSize) {
      final end =
          (i + chunkSize < dataStr.length) ? i + chunkSize : dataStr.length;
      print(dataStr.substring(i, end));
    }
  }
}
