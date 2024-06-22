import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
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
  DateTime? _fromDate, _toDate;
  Timestamp? _fromTime, _toTime;
  int? _totalHours;
  int? _totalPrice;
  String? _status;

  Map<String, dynamic> vData = {};
  bool? get homeVisit => _homeVisit;
  bool? get houseSitting => _houseSitting;
  String? get ownerEmail => _ownerEmail;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  Timestamp? get fromTime => _fromTime;
  Timestamp? get toTime => _toTime;
  int? get totalHours => _totalHours;
  int? get totalPrice => _totalPrice;
  String? get status => _status;
  List<Map<String, dynamic>> get petList => _petList;
  String uid = '';

  FireStoreService _fireStoreService = FireStoreService();

  Future<void> loadDetails(BuildContext context) async {
    print("Before data ---------------");
    uid = Provider.of<VolunteerDetailsGetterProvider>(context, listen: false)
        .currentuid;

    print(uid);
    vData = (await _fireStoreService.getVolunteerDetails(uid))!;
    if (vData != null) {
      print("Vol data is jhol data :  $vData");

      _houseSitting = vData['providesHouseSitting'];
      _houseSittingPrice = vData['providesHouseSittingPrice'];

      print('HouseSitting type is $_houseSitting');
      print("HouseSitting price is $_houseSittingPrice");

      // Notify listeners to update the UI
      notifyListeners();
    } else {
      print("Volunteer data is null");
    }
  }

  void loadPetData(BuildContext context) async {
    String ownerEmail =
        await Provider.of<OwnerDetailsGetterProvider>(context).email;

    PetFireStoreService _petFireStore = PetFireStoreService();

    _petList = await _petFireStore.getPets(ownerEmail);

    print(" Pet List is :   $_petList");
  }
}
