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
      Map<String, dynamic>? vDataAddress,
    Map<String, dynamic>?  oaddressDetails,
    required String vpa
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
        'status': 'booked',
        'vDataAddress': vDataAddress,
        'oaddressDetails':oaddressDetails,
        'vpa' : vpa
      });
      return bookingId;
    } catch (e) {
      print('Error saving booking: $e');
      throw e;
    }
  }

  Future<void> addVpaToBooking(String bookingId, String vpa) async {
    try {
      DocumentReference bookingRef =
          _firestore.collection('bookings').doc(bookingId);
      await bookingRef.update({'vpa': vpa});
      print('VPA added to booking successfully');
    } catch (e) {
      print('Error adding VPA to booking: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('bookings').doc(bookingId).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("No bookings found");
        return null;
      }
    } catch (e) {
      print("Error getting booking: $e");
      throw e;
    }
  }


  
   Future<List<Map<String, dynamic>>> getBookings(String volEmail, String status) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('volEmail', isEqualTo: volEmail)
          .where('status', isEqualTo: status)
          .get();

      return querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error getting bookings: $e");
      throw e;
    }
  }
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
  try {
    DocumentReference bookingRef = _firestore.collection('bookings').doc(bookingId);
    await bookingRef.update({'status': newStatus});
    print('Booking status updated successfully');
  } catch (e) {
    print('Error updating booking status: $e');
    throw e;
  }
}

Future<List<Map<String, dynamic>>> getBookingDetailsByOwnerEmail(String ownerEmail, String status) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('ownerEmail', isEqualTo: ownerEmail)
        .where('status',isEqualTo: status)
        .get();
    return querySnapshot.docs
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print("Error getting booking details: $e");
    throw e;
  }
}


Future<void> deleteBookingById(String bookingId) async {
  try {
    DocumentReference bookingRef = _firestore.collection('bookings').doc(bookingId);
    await bookingRef.delete();
    print('Booking deleted successfully');
  } catch (e) {
    print('Error deleting booking: $e');
    throw e;
  }
}


}
