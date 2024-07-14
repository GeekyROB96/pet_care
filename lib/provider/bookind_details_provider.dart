import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/pages/owner&pet/owner_editprofile.dart';
import 'package:pet_care/provider/owner_provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/volunteer_provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/firestore_service/booking_firestore.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
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
  Map<String, dynamic> vData = {};
  Map<String, dynamic>? _vDataAddress;
  Map<String, dynamic>? _oaddressDetails;
  String _vpa = '';

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
  Map<String, dynamic>? get vDataAddress => _vDataAddress;
  Map<String, dynamic>? get oaddressDetails => _oaddressDetails;

  FireStoreServiceVolunteer _fireStoreServiceVolunteer =
      FireStoreServiceVolunteer();
  BookingFirestore _bookingFirestore = BookingFirestore();
  FirestoreServiceOwner firestoreServiceOwner = FirestoreServiceOwner();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> initializeOwnerEmail() async {
    _ownerEmail = _firebaseAuth.currentUser?.email;
    notifyListeners();
  }

  void setVDataAddress(Map<String, dynamic>? vDataAddress) {
    _vDataAddress = vDataAddress;
    notifyListeners();
  }

  void setODataAddress(Map<String, dynamic>? oAddress) {
    _oaddressDetails = oAddress;
    notifyListeners();
  }

  Future<void> getVaddress(BuildContext context) async {
    var vData =
        await _fireStoreServiceVolunteer.getVolunteerAddressByEmail(volEmail);
    setVDataAddress(vData!);
    print("Volunteer Address: $vDataAddress");

    if (vDataAddress != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Volunteer Address'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Area, Apartment, Road: ${vDataAddress!['area_apartment_road']}',
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  'Description ${vDataAddress!['main']}',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  'Pincode ${vDataAddress!['pincode']}',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  'Directions: ${vDataAddress!['description_directions']}',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8398EC),
                  fixedSize: Size(120, 40),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      print("No address found for the volunteer with email $volEmail");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No address found for the volunteer')),
      );
    }
  }

  void fetchOAddressAndShowDialog(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var oData = await firestoreServiceOwner.getAddressDetails(userId);

      setODataAddress(oData!);

      if (oData != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Owner Address'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Area, Apartment, Road: ${oaddressDetails?['area_apartment_road']}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'House/Flat Details: ${oaddressDetails?['house_flat_data']}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Directions: ${oaddressDetails?['description_directions']}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OwnerEditProfilePage()));
                  },
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8398EC),
                      fixedSize: Size(120, 40),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8398EC),
                      fixedSize: Size(120, 40),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch owner address')),
        );
      }
    } catch (e) {
      print("Error fetching owner address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch owner address')),
      );
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
      _vpa = vData['vpa'];
      notifyListeners();
    } else {}
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
      ToastNotification.showToast(
        context,
        message: 'Please fill every field',
        type: ToastType.normal,
      );
      return;
    }

    print("ownerEmail : $_ownerEmail");
    print("volEmail  : $_volEmail");
    print("service: $_service");
    print("totalHours: $_totalHours");
    print("totalPrice : $_totalPrice");
    print("start and end date : $_startDate   : $_endDate");
    print("pet : $_pet");

    try {
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
          vDataAddress: service == 'House Sitting' ? _vDataAddress : null,
          oaddressDetails: service == 'Home Visit' ? _oaddressDetails : null,
          vpa: _vpa);

      showBookingSuccessDialog(context, bookingId);
    } catch (e) {
      ToastNotification.showToast(context,
          message: 'Error! $e', type: ToastType.error);
    }
  }

  void showBookingSuccessDialog(BuildContext context, String bookingId) {
    clearData();
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

  void clearData() {
    _oaddressDetails = null;
    _vDataAddress = null;
    notifyListeners();
  }
}
