import 'package:cloud_firestore/cloud_firestore.dart';

class BookingFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveBooking({
    required String ownerEmail,
    required String volEmail,
    required String service,
    required String servicePrice,
    required List<String> pet,
    required String startDate,
    required String endDate,
    required double totalHours,
    required double totalPrice,
  }) async {
    try {
      DocumentReference bookingRef = _firestore.collection('bookings').doc();
      String bookingId = bookingRef.id;
      await bookingRef.set({
        'bookingId': bookingId,
        'ownerEmail': ownerEmail,
        'volEmail': volEmail,
        'service': service,
        'servicePrice': servicePrice,
        'pet': pet,
        'startDate': startDate,
        'endDate': endDate,
        'totalHours': totalHours,
        'totalPrice': totalPrice,
        'status' : 'booked'
      });
      return bookingId;
    } catch (e) {
      print('Error saving booking: $e');
      throw e;
    }
  }
}
