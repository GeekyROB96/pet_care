import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/pages/owner&pet/payments_page.dart';
import 'package:pet_care/pages/screens/reminder_screen.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_dashboard_provider.dart';
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
                  'Hello Hooman',
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
                                  final isNetworkImage = Uri.tryParse(imagePath)
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
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: imagePath == null
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.blueGrey.withOpacity(0.3),
                                        backgroundImage: imagePath != null
                                            ? (isNetworkImage
                                                    ? NetworkImage(imagePath)
                                                    : FileImage(
                                                        File(imagePath)))
                                                as ImageProvider
                                            : AssetImage(
                                                    'assets/images/cat.png')
                                                as ImageProvider,
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
              'Pet Details:',
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
                      Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;

                  bool isFlipped = false;
                  return GestureDetector(
                    onTap: () async {
                      isFlipped = !isFlipped;
                      await petsDetailsProvider.navigateAndgetPetByName(
                          pet['petName'], pet['ownerEmail'], context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
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
                                    : AssetImage('assets/images/cat.png')
                                        as ImageProvider,
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
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
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
                      icon: Image.asset(
                        'assets/icons/ho.gif',
                        width: 30,
                        height: 30,
                      ),
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
                        // Add your onPressed logic here
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
                        // Add your onPressed logic here
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
            ],
            onTap: (index) {
              if (index == 0) {
                // Navigate to Home page
                Navigator.pushNamed(context, '/');
              } else if (index == 1) {
                // Navigate to Favorites page

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) {
                          return PaymentPage(bookingId: "9VLTRRMDQOvP44YkOWca"
                              );
                                  },
                                ),
                              );

              }       else if (index == 2) {
                // Navigate to Notifications page
                Navigator.pushNamed(context, '/notifications');
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
