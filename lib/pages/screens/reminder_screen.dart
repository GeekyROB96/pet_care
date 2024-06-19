import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../constants/theme/light_colors.dart';
import '../../provider/reminder_provider.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _reminderController = TextEditingController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int selectedCategoryIndex = -1;

  final List<String> icons = [
    'assets/icons/walk.png',
    'assets/icons/feed.png',
    'assets/icons/play.png',
    'assets/icons/sleep.png',
    'assets/icons/vaccine.png',
    'assets/icons/vet.png',
    'assets/icons/timer.png',
  ];

  final List<String> labels = [
    "Walk",
    "Feed",
    "Play",
    "Sleep",
    "Vaccine",
    "Vet",
    "Timer",
  ];

  List<bool> isSelected = List.generate(7, (index) => false);

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(
      android: android,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);

    // Fetch reminders on init
    Provider.of<ReminderProvider>(context, listen: false).fetchReminders();
  }

  void _addReminder(String reminderText) async {
    if (reminderText.isNotEmpty && selectedCategoryIndex != -1) {
      DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      try {
        // Save to Firebase
        await Provider.of<ReminderProvider>(context, listen: false)
            .addReminder(reminderText, selectedCategoryIndex, finalDateTime);

        _scheduleNotification(reminderText, finalDateTime);
        _reminderController.clear();
        setState(() {
          selectedCategoryIndex = -1;
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to save reminder. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _scheduleNotification(
      String reminderText, DateTime scheduledTime) async {
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        'Reminder', // Notification title
        reminderText, // Notification content
        tzScheduledTime, // Scheduled date and time
        notificationDetails,
        androidAllowWhileIdle:
            true, // Allow notification to be delivered even when the device is in idle doze mode
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  String formatTimestamp(DateTime timestamp) {
    return '${timestamp.day} ${_getMonthName(timestamp.month)} ${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      ReminderProvider reminderProvider, String reminderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reminder'),
          content: Text(
            'Are you sure you want to delete this reminder?',
            style: TextStyle(
              color: LightColors.textColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: LightColors.textColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: LightColors.textColor,
                ),
              ),
              onPressed: () async {
                await reminderProvider.deleteReminder(reminderId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  void _showAddReminderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 1.0,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(icons.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Toggle isSelected for the tapped index
                                  isSelected[index] = !isSelected[index];
                                  if (isSelected[index]) {
                                    selectedCategoryIndex = index;
                                  } else {
                                    selectedCategoryIndex = -1;
                                  }
                                  print(
                                      'Selected Category Index: $selectedCategoryIndex');
                                });
                              },
                              child: Card(
                                elevation: 4.0,
                                color: selectedCategoryIndex == index
                                    ? Colors.deepPurple.withOpacity(0.5)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                    color: selectedCategoryIndex == index
                                        ? LightColors.primaryColor
                                        : Colors.grey.shade800,
                                    width: 1.0,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  width: 130,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        icons[index],
                                        width: 30,
                                        height: 40,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        labels[index],
                                        style: TextStyle(
                                          color: selectedCategoryIndex == index
                                              ? LightColors.primaryColor
                                              : LightColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 30),
                      MyTextField(
                        hintText: 'Enter the reminder',
                        obsText: false,
                        controller: _reminderController,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(16),
                        textStyle: TextStyle(color: LightColors.textColor),
                        fillColor: LightColors.backgroundColor,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8),
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${_selectedDate.toLocal()}'.split(' ')[0],
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showDatePicker(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8),
                                Text(
                                  'Time:',
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _selectedTime.format(context),
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (picked != null) {
                                  setState(() {
                                    _selectedTime = picked;
                                    print('Selected Time: $_selectedTime');
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print('Category Index: $selectedCategoryIndex');
                          print('Reminder Text: ${_reminderController.text}');
                          print('Selected Date: $_selectedDate');
                          print('Selected Time: $_selectedTime');

                          if (selectedCategoryIndex == -1 ||
                              _reminderController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Incomplete Fields'),
                                  content: Text(
                                    'Please select all fields before saving the reminder.',
                                    style: TextStyle(
                                      color: LightColors.textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: LightColors.textColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            _addReminder(_reminderController.text);
                            Navigator.of(context)
                                .pop(); // Close the bottom sheet
                          }
                        },
                        child: Text(
                          'Save Reminder',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurpleAccent.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reminders',
            ),
            SizedBox(width: 8),
            Icon(
              Icons.alarm_add_outlined,
              size: 25,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddReminderBottomSheet(context);
              },
              child: Text(
                'Add Reminder',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<ReminderProvider>(
                builder: (context, reminderProvider, child) {
                  if (reminderProvider.reminders.isEmpty) {
                    return Center(
                      child: Text(
                        'No reminders found',
                        style: TextStyle(
                          color: LightColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: reminderProvider.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminderProvider.reminders[index];
                      final DateTime timestamp = reminder['timestamp'];
                      final categoryIndex = reminder['categoryIndex'];

                      final formattedTimestamp = formatTimestamp(timestamp);
                      return Column(
                        children: [
                          ListTile(
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            tileColor: Color.fromARGB(30, 180, 180, 185),
                            leading: Image.asset(
                              icons[
                                  categoryIndex], // Use icon based on category index
                              width: 40,
                              height: 40,
                            ),
                            title: Text(reminder['reminderText']),
                            subtitle: Text(formattedTimestamp),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                _showDeleteConfirmationDialog(
                                  context,
                                  reminderProvider,
                                  reminder['id'],
                                  //reminder['reminderText'],
                                );
                              },
                            ),
                          ),
                          Divider(
                            color: Color.fromARGB(30, 180, 180, 185),
                          ), // Add a divider after each tile
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
