import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/services/firestore_service/owner_firestore.dart';
import 'package:pet_care/services/firestore_service/volunteer_firestore.dart';

abstract class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<String?> getCurrentUserRole() async {
    // This function retrieves the role of the current user from Firestore
    try {
      String? userId = getCurrentUserId();
      if (userId != null) {
        // Determine the role based on Firestore data
        // For now, we'll assume 'owner' or 'volunteer' as role
        // You should adapt this to your actual Firestore schema
        if (await isOwner(userId)) {
          return 'owner';
        } else if (await isVolunteer(userId)) {
          return 'volunteer';
        } else {
          return null; // Handle if neither role is found
        }
      } else {
        return null; // Handle if userId is null
      }
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<bool> isOwner(String userId) async {
    // Implement logic to check if the user is an owner
    final ownerService = FirestoreServiceOwner();
    Map<String, dynamic>? userDetails = await ownerService.getOwnerDetails(userId);
    return userDetails != null && userDetails['role'] == 'owner';
  }

  Future<bool> isVolunteer(String userId) async {
    // Implement logic to check if the user is a volunteer
    final volunteerService = FireStoreServiceVolunteer();
    Map<String, dynamic>? userDetails = await volunteerService.getVolunteerDetails(userId);
    return userDetails != null && userDetails['role'] == 'volunteer';
  }
}

class AuthServiceOwner extends AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreServiceOwner _firestoreService = FirestoreServiceOwner();

  @override
  Future<String?> getCurrentUserRole() async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      // Retrieve user details from Firestore based on userId
      Map<String, dynamic>? userDetails = await _firestoreService.getOwnerDetails(userId);
      if (userDetails != null) {
        return userDetails['role'];
      }
    }
    return null;
  }
}

class AuthServiceVolunteer extends AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FireStoreServiceVolunteer _firestoreService = FireStoreServiceVolunteer();

  @override
  Future<String?> getCurrentUserRole() async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      // Retrieve user details from Firestore based on userId
      Map<String, dynamic>? userDetails = await _firestoreService.getVolunteerDetails(userId);
      if (userDetails != null) {
        return userDetails['role'];
      }
    }
    return null;
  }
}
