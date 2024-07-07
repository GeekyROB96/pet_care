import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/services/firestore_service/booking_firestore.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';

import '../services/firestore_service/owner_firestore.dart';

class BookingDetailsGetterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BookingFirestore _bookingFirestore = BookingFirestore();
  final PetFireStoreService _petFireStoreService = PetFireStoreService();
  final FirestoreServiceOwner _firestoreServiceOwner =
      FirestoreServiceOwner(); // Initialize FirestoreServiceOwner

  String? _volunteerEmail;
  Map<String, dynamic>? _selectedBooking;
  Map<String, dynamic>? _ownerDetails;

  String? get volunteerEmail => _volunteerEmail;
  Map<String, dynamic>? get selectedBooking => _selectedBooking;
  Map<String, dynamic>? get ownerDetails => _ownerDetails;

  BookingDetailsGetterProvider() {
    _fetchCurrentUserEmail();
  }

  Future<void> _fetchCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _volunteerEmail = user.email;
      print("Current Vol is : ${volunteerEmail}");
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getBookings(String status) async {
    if (_volunteerEmail == null) return [];
    List<Map<String, dynamic>> bookings =
        await _bookingFirestore.getBookings(_volunteerEmail!, status);

    // Fetch pet details for each booking
    for (var booking in bookings) {
      List<dynamic> petNames = booking['pet'];
      List<Map<String, dynamic>> petDetails = [];
      for (String petName in petNames) {
        var petDetail = await _petFireStoreService.getPetDetailsByName(
            booking['ownerEmail'], petName);
        if (petDetail != null) {
          petDetails.add(petDetail);
        }
      }
      booking['petDetails'] = petDetails;
    }
    return bookings;
  }

  Future<void> fetchBookingDetailsAndNavigate(
      BuildContext context, String bookingId) async {
    _selectedBooking = await _bookingFirestore.getBookingById(bookingId);
    notifyListeners();
    Navigator.pushNamed(context, '/bookingDetailsShow');
  }

  Future<void> fetchOwnerDetailsByEmail(String ownerEmail) async {
    _ownerDetails =
        await _firestoreServiceOwner.getOwnerDetailsByEmail(ownerEmail);
    notifyListeners();
  }
}
