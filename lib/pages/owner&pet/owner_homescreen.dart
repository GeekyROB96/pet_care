import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/screens/reminder_screen.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/owner_provider/owner_dashboard_provider.dart';
import 'package:pet_care/provider/reminder_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';

class OwnerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petsDetailsProvider = Provider.of<PetsDetailsGetterProvider>(context);
    final ownerDashboardProvider = Provider.of<OwnerDashboardProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello Hooman 👋',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ownerEditProfile');
                  },
                  child: Consumer<OwnerDetailsGetterProvider>(
                    builder: (context, ownerProvider, child) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: ownerProvider.profileImageUrl != null
                              ? Image.network(
                                  ownerProvider.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  height: 60,
                                  width: 60,
                                )
                              : Icon(Icons.person, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Consumer<PetsDetailsGetterProvider>(
                      builder: (context, petsDetailsProvider, child) {
                        return petsDetailsProvider.isDataLoaded
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: petsDetailsProvider.pets.length,
                                itemBuilder: (context, index) {
                                  final pet = petsDetailsProvider.pets[index];
                                  final imagePath = pet['imagePath'];
                                  final isNetworkImage =
                                      Uri.tryParse(imagePath ?? '')
                                              ?.hasAbsolutePath ??
                                          false;

                                  return GestureDetector(
                                    onTap: () {
                                      ownerDashboardProvider
                                          .selectPetIndex(index);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: ownerDashboardProvider
                                                    .selectedPetIndex ==
                                                index
                                            ? 0.5
                                            : 1.0,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.3),
                                          backgroundImage: imagePath != null
                                              ? (isNetworkImage
                                                      ? NetworkImage(imagePath)
                                                      : FileImage(
                                                          File(imagePath)))
                                                  as ImageProvider
                                              : AssetImage(
                                                  'assets/images/cat.png'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/pets');
                      await petsDetailsProvider.loadPets();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Pet Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Consumer<OwnerDashboardProvider>(
              builder: (context, ownerDashboardProvider, child) {
                if (petsDetailsProvider.isDataLoaded &&
                    petsDetailsProvider.pets.isNotEmpty) {
                  final pet = petsDetailsProvider
                      .pets[ownerDashboardProvider.selectedPetIndex];
                  final imagePath = pet['imagePath'];
                  final isNetworkImage =
                      Uri.tryParse(imagePath ?? '')?.hasAbsolutePath ?? false;

                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: GestureDetector(
                      key: ValueKey<String>(pet['petName']),
                      onTap: () async {
                        await petsDetailsProvider.navigateAndgetPetByName(
                            pet['petName'], pet['ownerEmail'], context);
                      },
                      child: Container(
                        key: ValueKey<String>(pet['petName']),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFB6D4F3),
                              Color(0xFFD5B7E8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imagePath != null
                                      ? (isNetworkImage
                                              ? NetworkImage(imagePath)
                                              : FileImage(File(imagePath)))
                                          as ImageProvider
                                      : AssetImage('assets/images/cat.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${pet['petName']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Breed: ${pet['breed']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Age: ${pet['age']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/images/poster3.jpg',
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Explore our services!',
                        textStyle: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        speed: Duration(milliseconds: 200),
                      ),
                      TypewriterAnimatedText(
                        'We provide the best service at hand.',
                        textStyle: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                        speed: Duration(milliseconds: 200),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/be.gif',
                          width: 30, height: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (_) => ReminderProvider(),
                              child: ReminderScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Reminder',
                      style: TextStyle(
                        color: LightColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/ho.gif',
                          width: 30, height: 30),
                      onPressed: () {
                        Navigator.pushNamed(context, '/petSitters');
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pet Sitting',
                      style: TextStyle(
                        color: LightColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/sa.gif',
                          width: 30, height: 30),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/lostPet',
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Lost your pet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LightColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/mo.gif',
                          width: 30, height: 30),
                      onPressed: () {
                        // Dialog Box
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('More Services'),
                              content: Container(
                                width: double.maxFinite,
                                height: 150,
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment
                                      .center, // Center align items
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/reminder');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/be.gif',
                                              width: 40, height: 40),
                                          SizedBox(height: 8),
                                          Text('Reminder',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/petSitters');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/ho.gif',
                                              width: 40, height: 40),
                                          SizedBox(height: 8),
                                          Text('Pet Sitting',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/lostPet');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/sa.gif',
                                              width: 40, height: 40),
                                          SizedBox(
                                              height:
                                                  8), // Add vertical space between icon and text
                                          Text('Lost your pet',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            8), // Add vertical space between icons
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/ownerBookingTile');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/icons/history.gif',
                                              width: 40,
                                              height: 40),
                                          SizedBox(height: 8),
                                          Text('History',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/lostPetShowTileOwner');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/lost.gif',
                                              width: 40, height: 40),
                                          SizedBox(height: 8),
                                          Text('Lost Pets',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      'More',
                      style: TextStyle(
                        color: LightColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              Icon(Icons.favorite, size: 30, color: Colors.black),
              Icon(Icons.notifications, size: 30, color: Colors.black),
              Icon(Icons.more_horiz_outlined, size: 30, color: Colors.black)
            ],
            onTap: (index) {
              if (index == 0) {
                // Navigate to Home page
                Navigator.pushNamed(context, '/');
              } else if (index == 1) {
                // Navigator.pushNamed(context, '/ownerBookingTile');
              } else if (index == 2) {
                // Navigate to Notifications page
                Navigator.pushNamed(context, '/notifications');
              } else if (index == 3) {
                //Navigator.pushNamed(context, '/lostPetShowTileOwner');
              }
            },
          ),
        ],
      ),
    );
  }
}

// Custom painter class for the curved bottom navigation bar
class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
