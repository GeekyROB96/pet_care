import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storePayment({
    required String payeeName,
    required String bookingId,
    required String vpa,
    required String volEmail,
    required String status,
    required double amount,
  }) async {
    try {
      // Check if payment already exists for this bookingId
      String? existingStatus = await getPaymentStatusByBookingId(bookingId);
      if (existingStatus != null) {
        print('Payment with booking ID $bookingId already exists. Cannot proceed.');
        return;
      }

      // Proceed with storing payment details
      DocumentReference paymentRef = _firestore.collection('payments').doc();
      String paymentId = paymentRef.id;

      await paymentRef.set({
        'paymentId': paymentId,
        'payeeName': payeeName,
        'bookingId': bookingId,
        'vpa': vpa,
        'volEmail': volEmail,
        'status': status,
        'amount': amount,
      });
      print('Payment details stored successfully in Firestore');
    } catch (e) {
      print('Failed to store payment details: $e');
      // Handle error as needed
    }
  }

  Future<String?> getPaymentStatusByBookingId(String bookingId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('payments')
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String status = querySnapshot.docs.first['status'];
        return status;
      } else {
        print('No payment found with the given booking ID');
        return null;
      }
    } catch (e) {
      print('Failed to get payment status: $e');
      return null;
    }
  }


  Future<void> updatePaymentStatus({
    required String bookingId,
    required String newStatus,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('payments')
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String paymentId = docSnapshot.id;

        await _firestore.collection('payments').doc(paymentId).update({
          'status': newStatus,
        });

        print('Payment status updated successfully');
      } else {
        print('No payment found with the given booking ID');
      }
    } catch (e) {
      print('Failed to update payment status: $e');
      // Handle error as needed
    }
  }

  Future<List<Map<String, dynamic>>?> getPaymentDetailsByBookingId(String bookingId) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('payments')
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
        .toList();
    } else {
      print('No payment details found for the given booking ID');
      return null;
    }
  } catch (e) {
    print('Failed to get payment details: $e');
    throw e;
  }
}

}
