import 'package:flutter/material.dart';
import 'package:pet_care/constants/custom_toast.dart';
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

  String? _paymentStatus;

  String? _orderStatus;

  var paymentData;
  bool _isLoading = true; // Add this property
  bool get isLoading => _isLoading;


  

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

  void setPaymentStatus(String paymentStatus) {
    _paymentStatus = paymentStatus;
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
  String? get paymentStatus => _paymentStatus;

  BookingFirestore _bookingFirestore = BookingFirestore();
  FireStoreServiceVolunteer _fireStoreServiceVolunteer =
      FireStoreServiceVolunteer();

  PaymentFirestoreService _paymentFirestoreService = PaymentFirestoreService();

  Future<void> loadData(String bookingId, BuildContext context) async {
    setBookingId(bookingId);
    _isLoading = true; // Set loading state to true
    notifyListeners();

    try {
      Map<String, dynamic>? bookingDetails =
          await _bookingFirestore.getBookingById(bookingId);
      if (bookingDetails != null) {
        setAmount(bookingDetails['totalPrice']?.toDouble() ?? 0.0);
        setVpa(bookingDetails['vpa'] ?? '');
        setVEmail(bookingDetails['volEmail'] ?? '');
        setOrderStatus(bookingDetails['status'] ?? '');
        print("vemail : $_vEmail");

        _orderStatus = await _paymentFirestoreService
            .getPaymentStatusByBookingId(bookingId);

        await loadVNameandImage(context);
        await getPaymentStatus();
        notifyListeners();
      } else {
        print('No booking details found for bookingId: $bookingId');
      }
    } catch (e) {
      print('Error loading booking details: $e');
    }

     _isLoading = false;  // Set loading state to false after data is loaded
    notifyListeners();
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
      setPaymentStatus('Payment Done ! Reciever Confirmation Pending');

      notifyListeners();
      //print("Payment Done");
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

  Future<void> getPaymentStatus() async {
    try {
      _paymentStatus = await _paymentFirestoreService
          .getPaymentStatusByBookingId(bookingId!);
      setPaymentStatus(_paymentStatus!);
      notifyListeners();
      print("Payment Status is : $_paymentStatus");
    } catch (e) {
      print("Error fetching payment status! $e");
    }
  }
}
