import 'dart:convert'; // Import for jsonEncode

import 'package:flutter/material.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';


class PetSitterProvider with ChangeNotifier {
  final FireStoreService _fireStoreService = FireStoreService();
  List<Map<String, dynamic>> _volunteers = [];
  bool _isLoading = false;
  bool _sortByHomeVisiting = false; // Track if sorting by home visiting

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
      if (_sortByHomeVisiting) {
        _volunteers.sort((a, b) =>
            (a['providesHomeVisitsPrice'] ?? 0).compareTo(b['providesHomeVisitsPrice'] ?? 0));
      } else {
        _volunteers.sort((a, b) =>
            (a['providesHouseSittingPrice'] ?? 0).compareTo(b['providesHouseSittingPrice'] ?? 0));
      }
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
      if (_sortByHomeVisiting) {
        _volunteers.sort((a, b) =>
            (b['providesHomeVisitsPrice'] ?? 0).compareTo(a['providesHomeVisitsPrice'] ?? 0));
      } else {
        _volunteers.sort((a, b) =>
            (b['providesHouseSittingPrice'] ?? 0).compareTo(a['providesHouseSittingPrice'] ?? 0));
      }
      notifyListeners();
      _logLargeData(_volunteers);
    } catch (e) {
      print("Error sorting volunteers: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void toggleSortByHomeVisiting(bool value) {
    _sortByHomeVisiting = value;
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