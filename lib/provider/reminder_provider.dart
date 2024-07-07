import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/model/reminder_model.dart';
import 'package:uuid/uuid.dart';

class ReminderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  Future<void> fetchReminders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('reminders').get();
      _reminders = snapshot.docs.map((doc) {
        return Reminder(
          id: doc.id,
          title: doc['title'],
          categoryIndex: doc['categoryIndex'],
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching reminders: $e');
    }
  }

  Future<void> addReminder(
      String title, int categoryIndex, DateTime timestamp) async {
    try {
      String id = Uuid().v4(); // Generate a unique ID for the reminder
      Reminder newReminder = Reminder(
        id: id,
        title: title,
        categoryIndex: categoryIndex,
        timestamp: timestamp,
      );
      await _firestore.collection('reminders').doc(id).set({
        'title': title,
        'categoryIndex': categoryIndex,
        'timestamp': Timestamp.fromDate(timestamp),
      });
      _reminders.add(newReminder);
      notifyListeners();
    } catch (e) {
      print('Error adding reminder: $e');
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _firestore.collection('reminders').doc(reminderId).delete();
      _reminders.removeWhere((reminder) => reminder.id == reminderId);
      notifyListeners();
    } catch (e) {
      print('Error deleting reminder: $e');
    }
  }
}
