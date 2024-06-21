import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final int categoryIndex;
  final DateTime timestamp;

  Reminder({
    required this.id,
    required this.title,
    required this.categoryIndex,
    required this.timestamp,
  });
}
