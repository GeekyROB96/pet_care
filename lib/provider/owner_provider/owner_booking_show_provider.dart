import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/services/firestore_service/booking_firestore.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';

class BookingDetailsGetterOwnerProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BookingFirestore _bookingFirestore = BookingFirestore();
  final PetFireStoreService _petFireStoreService = PetFireStoreService();
  final FirestoreServiceOwner _firestoreServiceOwner = FirestoreServiceOwner();

  var petData;
  String _ownerEmail = '';
  bool _isSinglePetLoaded = false;
  bool _isDataLoaded = false;

  String get ownerEmail => _ownerEmail;
  bool get isDataLoaded => _isDataLoaded;
  bool get isSinglePetLoaded => _isSinglePetLoaded;

  Map<String, dynamic>? _vDataAddress = null;
  Map<String, dynamic>? _oaddressDetails = null;

  List<Map<String, dynamic>> _pets = [];

  List<Map<String, dynamic>> get pets => _pets;

  String? _volunteerEmail;
  Map<String, dynamic>? _selectedBooking;
  Map<String, dynamic>? _ownerDetails;

  String? get volunteerEmail => _volunteerEmail;
  Map<String, dynamic>? get selectedBooking => _selectedBooking;
  Map<String, dynamic>? get ownerDetails => _ownerDetails;

  Map<String, dynamic>? get vDataAddress => _vDataAddress;
  Map<String, dynamic>? get oaddressDetails => _oaddressDetails;

  BookingDetailsGetterOwnerProvider() {
    _fetchCurrentUserEmail();
  }

  Future<void> _fetchCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _ownerEmail = user.email!;
      print("Current Owner is : ${ownerEmail}");
      notifyListeners();
    }
  }

  void setOwnerAddress(Map<String, dynamic> ownerAddress) {
    _oaddressDetails = ownerAddress;
    notifyListeners();
  }

  void setVolunteerAddress(Map<String, dynamic> volunteerAddress) {
    _vDataAddress = volunteerAddress;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getBookings(String status) async {
    if (_ownerEmail == null) return [];
    List<Map<String, dynamic>> bookings =
        await _bookingFirestore.getBookingDetailsByOwnerEmail(_ownerEmail, status);
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
      _ownerEmail = booking['ownerEmail'];
    }
    return bookings;
  }

  Future<void> fetchBookingDetailsAndNavigate(
      BuildContext context, String bookingId) async {
    _selectedBooking = await _bookingFirestore.getBookingById(bookingId);
    notifyListeners();
    Navigator.pushNamed(context, '/bookingDetailsShowOwner');
  }

  Future<void> fetchOwnerDetailsByEmail(String ownerEmail) async {
    _ownerDetails =
        await _firestoreServiceOwner.getOwnerDetailsByEmail(ownerEmail);
    notifyListeners();
  }

  Future<void> navigateAndgetPetByName(
      String petName, String ownermail, BuildContext context) async {
    _isSinglePetLoaded = false;
    notifyListeners();

    try {
      petData =
          await _petFireStoreService.getPetDetailsByName(ownermail, petName);
      _isSinglePetLoaded = true;
      notifyListeners();
      print("Pet Data: $petData");

      navigateToPetProfile(context);
    } catch (e) {
      print("Error fetching pet data: $e");
      _isSinglePetLoaded =
          true; // Ensure to set back to true on error to avoid infinite loading state
      notifyListeners();
    }
  }

  Future<void> loadPets() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        _pets.clear();

        _pets = await _petFireStoreService.getPets(user.email!);
        _isDataLoaded = true;
        notifyListeners();
      } catch (e) {
        print("Error loading pets data: $e");
      }
    } else {
      print("No user logged in.");
    }
  }

  void navigateToPetProfile(BuildContext context) {
    Navigator.pushNamed(context, '/petProfile2');
  }

  Future<void> updateBooking(
      String bookingId, String newStatus, BuildContext context) async {
    try {
      await _bookingFirestore.updateBookingStatus(bookingId, newStatus);

      ToastNotification.showToast(context,
          message: "Booking Status updated Successfully",
          type: ToastType.positive);
    } catch (e) {
      ToastNotification.showToast(context,
          message: "Error updating Booking Status", type: ToastType.error);
    }
  }

   Future<void> deleteBooking(String bookingId, BuildContext context) async {
    try {
      await _bookingFirestore.deleteBookingById(bookingId);
      ToastNotification.showToast(context,
          message: "Booking deleted successfully", type: ToastType.positive);
      Navigator.pop(context);
    } catch (e) {
      ToastNotification.showToast(context,
          message: "Error $e", type: ToastType.error);
      print("Error : $e");
    }
  }
}
