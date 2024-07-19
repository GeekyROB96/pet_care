import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/services/firestore_service/lost_pet_firestore.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:maps_toolkit/maps_toolkit.dart';

class LostPetDetailsGetterVolunteer extends ChangeNotifier {
  final LostPetFirestore _lostPetFirestore = LostPetFirestore();

  final FireStoreServiceVolunteer _fireStoreServiceVolunteer =
      FireStoreServiceVolunteer();

  final PetFireStoreService _petFireStoreService = PetFireStoreService();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentUserEmail;
  String get currentUserEmail => _currentUserEmail!;

  List<Map<String, dynamic>> _allLostPets = [];
  List<Map<String, dynamic>> get allLostPets => _allLostPets;

  var completePetDetail;
  var volunteerData;
  String? _distance;
  String? _petImageUrl;

  String? get petImageUrl => _petImageUrl;

  String? get distance => _distance;
  String? _petName;

  String? get petName => _petName;

  String breed = 'default';

  String? lastSeen;

  void getCurrentUserEmail() {
    User? user = _auth.currentUser;

    if (user != null) {
      _currentUserEmail = user.email;
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _setLoading(true);
    _setLoading(true);
    await fetchAllLostPets();
    getCurrentUserEmail();
    await getVolunteerDetails();

    await calculateDistances(); 
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchLostPetById(String petId) async {
    try {
      Map<String, dynamic>? petData =
          await _lostPetFirestore.getLostPetbyId(petId);
      if (petData != null) {
        print("Lost Pet Data by ID: $petData");
      } else {
        print("No lost pet found with ID: $petId");
      }
    } catch (e) {
      print('Error fetching lost pet by ID: $e');
    }
  }

  Future<void> fetchAllLostPets() async {
    try {
      _allLostPets = await _lostPetFirestore.getAllLostPets();
      if (_allLostPets.isNotEmpty) {
        _allLostPets.forEach((pet) async {
          String? petLastSeen = pet['lastSeen'];
          if (petLastSeen != null) {
            pet['lastSeen'] = _reformatLastSeen(petLastSeen);
            Map<String, String?> petDetails =
                await lostPetCompleteDetails(pet['ownerEmail'], pet['petName']);
            print(pet['petName']);
            pet['breed'] = petDetails['breed'];
            pet['selectedPetType'] = petDetails['selectedPetType'];
          }
          print(pet['address']['coordinates']);
        });
      } else {
        print("No lost pets found.");
      }
    } catch (e) {
      print('Error fetching all lost pets: $e');
    }
  }

  Future<void> getVolunteerDetails() async {
    volunteerData = await _fireStoreServiceVolunteer.getVolunteerDetailsByEmail(_currentUserEmail!);

    print("Vol Details: $volunteerData");

    print("\n owner data address: ${volunteerData['Address'][0]['coordinates']}");
  }

  Future<void> fetchLostPetByOwnerEmail(String ownerEmail) async {
    try {
      List<Map<String, dynamic>> ownerPets =
          await _lostPetFirestore.getLostPetbyOwnerEmail(ownerEmail);

      if (ownerPets.isNotEmpty) {
        print(" \nLost Pets Data by Owner Email:");
        ownerPets.forEach((pet) => print(pet));
      } else {
        print("No lost pets found for owner email: $ownerEmail");
      }
    } catch (e) {
      print('Error fetching lost pets by owner email: $e');
    }
  }

  Future<void> calculateDistances() async {
   

    String volunteerCoordinates = volunteerData['Address'][0]['coordinates'];
    print("Owner Coordinates: $volunteerCoordinates");

    for (var pet in _allLostPets) {
      String petCoordinates = pet['address']['coordinates'];
      String distance =
          await _calculateDistance(volunteerCoordinates, petCoordinates);
      pet['distance'] = distance; // Set the calculated distance
    }

    notifyListeners();
  }

  Future<String> _calculateDistance(String origin, String destination) async {
    // coudln't use maps api to calculate distance kyuki wo log paisa maang rha tha  - | -
    final originLatLng = _parseCoordinates(origin);
    final destinationLatLng = _parseCoordinates(destination);

    if (originLatLng == null || destinationLatLng == null) {
      return 'Invalid coordinates';
    }

    // Calculate the distance using maps_toolkit
    final distance = SphericalUtil.computeDistanceBetween(
      LatLng(originLatLng[0], originLatLng[1]),
      LatLng(destinationLatLng[0], destinationLatLng[1]),
    );

    // Convert the distance to kilometers and return as a string
    final distanceInKm = (distance / 1000).toStringAsFixed(2);
    return '$distanceInKm km';
  }

  List<double>? _parseCoordinates(String coordinates) {
    final parts = coordinates.split(',');
    if (parts.length != 2) return null;
    final latitude = double.tryParse(parts[0]);
    final longitude = double.tryParse(parts[1]);
    if (latitude == null || longitude == null) return null;
    return [latitude, longitude];
  }

  String _reformatLastSeen(String lastSeen) {
    final dateFormat = DateFormat("MMM dd, yyyy - hh:mm a");
    final lastSeenDate = dateFormat.parse(lastSeen);
    final now = DateTime.now();
    final difference = now.difference(lastSeenDate);

    if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else if (difference.inDays < 31) {
      return '${difference.inDays} days ago';
    } else {
      final monthsAgo = (difference.inDays / 30).floor();
      return '$monthsAgo months ago';
    }
  }

  Future<Map<String, String?>> lostPetCompleteDetails(
      String ownerEmail, String petName) async {
    try {
      completePetDetail =
          await _petFireStoreService.getPetDetailsByName(ownerEmail, petName);
      notifyListeners();
      return {
        'breed': completePetDetail['breed'],
        'selectedPetType': completePetDetail['selectedPetType']
      };
    } catch (e) {
      print("Error getting complete pet details: $e");
      throw e;
    }
  }


  void navigateTolostDetailsShowPage(){
    
  }
}
