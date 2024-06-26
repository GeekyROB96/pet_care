import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/snackbar.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/firestore_service/booking_firestore.dart';
import 'package:pet_care/services/firestore_service/pet_register.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';
import 'package:provider/provider.dart';

class BookingDetailsProvider extends ChangeNotifier {
  bool? _houseSitting;
  bool? _homeVisit;
  int? _houseSittingPrice;
  int? _homeVisitPrice;
  List<Map<String, dynamic>> _petList = [];
  String? _ownerEmail;
  String? _startDate;
  String? _endDate;
  Timestamp? _fromTime, _toTime;
  double? _totalHours;
  double? _totalPrice;
  String? _status;
  String? _service;
  String _servicePrice = '';

  String _volEmail = '';
  List<String>? _pet;
  //String? _ownerAddress;
  Map<String, dynamic> vData = {};

  bool? get homeVisit => _homeVisit;
  bool? get houseSitting => _houseSitting;
  int? get houseSittingPrice => _houseSittingPrice;
  int? get homeVisitPrice => _homeVisitPrice;
  String? get ownerEmail => _ownerEmail;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  Timestamp? get fromTime => _fromTime;
  Timestamp? get toTime => _toTime;
  double? get totalHours => _totalHours;
  double? get totalPrice => _totalPrice;
  String? get status => _status;
  List<Map<String, dynamic>> get petList => _petList;
  String uid = '';
  String get servicePrice => _servicePrice;

  String get volEmail => _volEmail;
  String? get service => _service;
  List<String>? get pet => _pet;

  var vDataAddress;
  FireStoreServiceVolunteer _fireStoreServiceVolunteer =
      FireStoreServiceVolunteer();
  BookingFirestore _bookingFirestore = BookingFirestore();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> initializeOwnerEmail() async {
    _ownerEmail = _firebaseAuth.currentUser?.email;
    notifyListeners();
  }

  void getVaddress() async {
    vDataAddress =
        await _fireStoreServiceVolunteer.getVolunteerAddressByEmail(volEmail);
    print(" Volunteer Address : $vDataAddress");
    if (vDataAddress != null) {
      print("Volunteer Address: $vDataAddress");
    } else {
      print("No address found for the volunteer with email $volEmail");
    }
  }

  Future<void> loadDetails(BuildContext context) async {
    uid = Provider.of<VolunteerDetailsGetterProvider>(context, listen: false)
        .currentuid;

    print(uid);
    vData = (await _fireStoreServiceVolunteer.getVolunteerDetails(uid))!;
    if (vData != null) {
      _volEmail = vData['email'];
      _houseSitting = vData['providesHouseSitting'];
      _houseSittingPrice = vData['providesHouseSittingPrice'];
      _homeVisit = vData['providesHomeVisits'];
      _homeVisitPrice = vData['providesHomeVisitsPrice'];
      notifyListeners();
    } else {
      // Handle case when vData is null
    }
  }

  Future<void> loadPetData(BuildContext context) async {
    String ownerEmail =
        Provider.of<OwnerDetailsGetterProvider>(context, listen: false).email;

    PetFireStoreService _petFireStore = PetFireStoreService();

    _petList = await _petFireStore.getPets(ownerEmail);
    notifyListeners();
  }

  void setStartDate(String startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  void setEndDate(String endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  void setService(String service) {
    _service = service;
    notifyListeners();
  }

  void setServicePrice(String servicePrice) {
    _servicePrice = servicePrice;
    notifyListeners();
  }

  void setTotalHours(double totalHours) {
    _totalHours = totalHours;
    notifyListeners();
  }

  void setTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
    notifyListeners();
  }

  void setPet(List<String> pet) {
    _pet = pet;
    notifyListeners();
  }

  Future<void> saveBooking(BuildContext context) async {
    if (_ownerEmail == null) {
      await initializeOwnerEmail();
    }

    if (_service == null ||
        _pet == null ||
        _totalHours == null ||
        _totalPrice == null) {
      showSnackBar(
          context, "Either service or pet or totalHours or totalPrice is null");
      return;
    }

    print("ownerEmail : $_ownerEmail");
    print("volEmail  : $_volEmail");
    print("service: $_service");
    print("totalHours: $_totalHours");
    print("totalPrice : $_totalPrice");
    print("start and end date : $_startDate   : $_endDate");
    print("pet : $_pet");

    String bookingId = await _bookingFirestore.saveBooking(
      ownerEmail: _ownerEmail!,
      volEmail: _volEmail,
      service: _service!,
      servicePrice: _servicePrice,
      pet: _pet!,
      startDate: _startDate!,
      endDate: _endDate!,
      totalHours: _totalHours!,
      totalPrice: _totalPrice!,
    );

    showBookingSuccessDialog(context, bookingId);
  }

  void showBookingSuccessDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/tick.gif',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Booking ID: $bookingId',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Your booking is sent .Please check for status 🎉',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
