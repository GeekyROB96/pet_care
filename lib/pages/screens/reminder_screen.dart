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
      // Save to Firebase or wherever you store reminders
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
  void _scheduleNotification(String reminderText, DateTime scheduledTime) async {
  final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

  try {
    // Generate a unique ID for each notification
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Example unique ID generation

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId, // Unique notification ID
      'Reminder', // Notification title
      reminderText, // Notification content
      tzScheduledTime, // Scheduled date and time
      notificationDetails,
      androidAllowWhileIdle: true, // Allow notification to be delivered even when the device is in idle mode
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
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
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Select Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(color: LightColors.textColor),
                              ),
                              trailing: Icon(
                                Icons.calendar_today,
                                color: LightColors.primaryColor,
                              ),
                              onTap: _selectDate,
                            ),
                            ListTile(
                              title: Text(
                                'Select Time: ${_selectedTime.format(context)}',
                                style: TextStyle(color: LightColors.textColor),
                              ),
                              trailing: Icon(
                                Icons.access_time,
                                color: LightColors.primaryColor,
                              ),
                              onTap: _selectTime,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          backgroundColor: LightColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          _addReminder(_reminderController.text);
                          Navigator.pop(context); // Close the BottomSheet
                        },
                        child: Text(
                          'Add Reminder',
                          style: TextStyle(fontSize: 20),
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

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      backgroundColor: LightColors.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 55,),
            const Text('Reminders'),
            const SizedBox(width: 4),
            const Icon(
              Icons.alarm_add_outlined,
              size: 25,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8,),
          Center(
            
            child: ElevatedButton(
              onPressed: () => _showAddReminderBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 52, 135, 243),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add Reminder'),
                  SizedBox(width: 3),
                  Icon(Icons.notification_add_outlined),
                ],
              ),
            ),
          ),
                    SizedBox(height: 10,),

          Expanded(
            child: reminderProvider.reminders.isEmpty
                ? Center(
                    child: Text(
                      'No reminders yet!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: reminderProvider.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminderProvider.reminders[index];
                      return Column(
                        children: [
                          Card(
                            elevation: 4.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 16.0),
                            child: ListTile(
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              tileColor: Color.fromARGB(30, 197, 197, 198),
                              leading: Image.asset(
                                icons[reminder.categoryIndex],
                                width: 30,
                                height: 30,
                              ),
                              title: Text(
                                reminder.title,
                                style: TextStyle(color: Colors.grey),
                              ),
                              subtitle: Text(
                                'Scheduled for: ${formatTimestamp(reminder.timestamp)}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, reminderProvider, reminder.id);
                                },
                              ),
                            ),
                          ),
                          Divider(
                            color: Color.fromARGB(30, 122, 122, 124),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
