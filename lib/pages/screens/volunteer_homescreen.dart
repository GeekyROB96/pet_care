import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/reminder_provider.dart';
import 'notification_screen.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Consumer<VolunteerDetailsGetterProvider>(
                builder: (context, volunteerProvider, child) {
              return Text(
                'Hello ${volunteerProvider.name}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/volunteerEditProfile');
              },
              child: Consumer<VolunteerDetailsGetterProvider>(
                builder: (context, volunteerProvider, child) {
                  return CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                      child: volunteerProvider.profileImageUrl != null
                          ? Image.network(
                              volunteerProvider.profileImageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person, color: Colors.white),
                    ),
                    backgroundColor: Colors.black45,
                  );
                },
              ),
            ),
          ]),
        ]),
      ),
      bottomNavigationBar: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: CurvedPainter(),
          ),
          CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Colors.transparent,
            buttonBackgroundColor: Colors.white,
            height: 60,
            items: <Widget>[
              Icon(Icons.home, size: 30, color: Colors.black),
              Icon(Icons.add_a_photo, size: 30, color: Colors.black),
              Icon(Icons.notifications, size: 30, color: Colors.black),
            ],
            onTap: (index) {
              // Handle navigation to different pages based on the index
              if (index == 0) {
                // Navigate to Home page
              } else if (index == 1) {
                // Navigate to Like/Favorites page
              } else if (index == 2) {
                // Navigate to Reminder page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => ReminderProvider(),
                      child: NotificationScreen(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..quadraticBezierTo(size.width * 0.5, -30, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
