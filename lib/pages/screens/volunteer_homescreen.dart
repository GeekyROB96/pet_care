import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/screens/user_message_list_page.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/reminder_provider.dart';
import 'notification_screen.dart';

final images = [
  'assets/sliding_images/sliding1.jpg',
  'assets/sliding_images/sliding6.jpg',
  'assets/sliding_images/sliding7.webp',
  'assets/sliding_images/sliding4.jpg',
  'assets/sliding_images/sliding4.webp',
];

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          child: volunteerProvider.imageUrl != null
                              ? Image.network(
                                  volunteerProvider.imageUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.person, color: Colors.white),
                        ),
                        backgroundColor: Colors.black45,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
           
            SlidingImagePage(),
          ],
        ),
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
              Icon(Icons.email_sharp, size: 30, color: Colors.black),
            ],
            onTap: (index) {
              if (index == 0) {
              } else if (index == 1) {
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => ReminderProvider(),
                      child: NotificationScreen(),
                    ),
                  ),
                );
              } else if (index == 3) {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListMessage()),
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

class SlidingImagePage extends StatefulWidget {
  const SlidingImagePage({Key? key}) : super(key: key);

  @override
  State<SlidingImagePage> createState() => _SlidingImagePageState();
}

class _SlidingImagePageState extends State<SlidingImagePage> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height *
              0.4, // Adjust the height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ImageCard(
                  imgList: images[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.imgList}) : super(key: key);
  final String imgList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AspectRatio(
          aspectRatio: 16 / 9, // Maintain the aspect ratio to avoid slicing
          child: Image.asset(
            imgList,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
