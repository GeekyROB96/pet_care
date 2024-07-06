import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:pet_care/services/firestore_service/booking_firestore.dart';
import 'package:pet_care/services/firestore_service/payment_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

class PaymentPageProvider extends ChangeNotifier {
  String? _bookingId;
  double? _amount;
  String? _vImageUrl;
  String? _vName;
  String? _vpa;
  String? _description;
  String? _vEmail;

  String? _orderStatus;

  // Setter methods
  void setBookingId(String bookingId) {
    _bookingId = bookingId;
    notifyListeners();
  }

  void setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  void setVImageUrl(String vImageUrl) {
    _vImageUrl = vImageUrl;
    notifyListeners();
  }

  void setVName(String vName) {
    _vName = vName;
    notifyListeners();
  }

  void setVpa(String vpa) {
    _vpa = vpa;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setVEmail(String vEmail) {
    _vEmail = vEmail;
    notifyListeners();
  }

  void setOrderStatus(String orderStatus) {
    _orderStatus = orderStatus;
    notifyListeners();
  }

  // Getters
  String? get bookingId => _bookingId;
  double? get amount => _amount;
  String? get vImageUrl => _vImageUrl;
  String? get vName => _vName;
  String? get vpa => _vpa;
  String? get description => _description;
  String? get vEmail => _vEmail;
  String? get orderStatus => _orderStatus;

  BookingFirestore _bookingFirestore = BookingFirestore();
  FireStoreServiceVolunteer _fireStoreServiceVolunteer =
      FireStoreServiceVolunteer();

  PaymentFirestoreService _paymentFirestoreService = PaymentFirestoreService();

  Future<void> loadData(String bookingId, BuildContext context) async {
    setBookingId(bookingId); // Use the setter method

    try {
      Map<String, dynamic>? bookingDetails =
          await _bookingFirestore.getBookingById(bookingId);
      if (bookingDetails != null) {
        setAmount(bookingDetails['totalPrice']?.toDouble() ?? 0.0);
        setVpa(bookingDetails['vpa'] ?? '');
        setVEmail(bookingDetails['volEmail'] ?? '');
        print("vemail : $_vEmail");

        _orderStatus = await _paymentFirestoreService
            .getPaymentStatusByBookingId(bookingId);

        await loadVNameandImage(context);
        notifyListeners();
      } else {
        print('No booking details found for bookingId: $bookingId');
      }
    } catch (e) {
      print('Error loading booking details: $e');
    }
  }

  Future<void> loadVNameandImage(BuildContext context) async {
    try {
      var vData =
          await _fireStoreServiceVolunteer.getVolunteerDetailsByEmail(_vEmail!);

      setVName(vData?['name'] ?? '');
      setVImageUrl(vData?['profileImageUrl'] ?? '');
      notifyListeners();
    } catch (e) {
      print('Error loading volunteer details: $e');
      throw (e);
    }
  }

  Future<void> confirmPayment() async {
    try {
      print("vname : $_vName");
      print("VPA: $_vpa");
      print("amount: $_amount");
      print("booking Id: $bookingId");
      print("vemail: $_vEmail");

      await _paymentFirestoreService.storePayment(
          payeeName: _vName!,
          bookingId: bookingId!,
          vpa: _vpa!,
          amount: _amount!,
          status: 'Payment Done ! Reciever Confirmation Pending',
          volEmail: _vEmail!);
      setOrderStatus('Payment Done ! Reciever Confirmation Pending');
      print("Payment Done");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updatePayment() async {
    try {
      await _paymentFirestoreService.updatePaymentStatus(
          bookingId: bookingId!, newStatus: orderStatus!);
      setOrderStatus('Payment Completed');
    } catch (e) {
      print("Error: $e");
    }
  }
}
