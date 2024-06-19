import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:pet_care/pages/screens/reminder_screen.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/owner_dashboard_provider.dart';
import 'package:pet_care/provider/reminder_provider.dart';
import 'package:provider/provider.dart';

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
                  child: CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.blue,
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
                                      Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;

                                  return GestureDetector(
                                    onTap: () {
                                      ownerDashboardProvider.selectPetIndex(index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: imagePath != null
                                            ? (isNetworkImage
                                                ? NetworkImage(imagePath)
                                                : FileImage(File(imagePath))) as ImageProvider
                                            : AssetImage('assets/images/cat.png') as ImageProvider,
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
                  final pet = petsDetailsProvider.pets[ownerDashboardProvider.selectedPetIndex];
                  final imagePath = pet['imagePath'];
                  final isNetworkImage =
                      Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;

                  return GestureDetector(
                    onTap: () async {
                      await petsDetailsProvider.navigateAndgetPetByName(
                          pet['petName'], pet['ownerEmail'], context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: imagePath != null
                                ? (isNetworkImage
                                    ? NetworkImage(imagePath)
                                    : FileImage(File(imagePath))) as ImageProvider
                                : AssetImage('assets/images/cat.png') as ImageProvider,
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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                'assets/icons/reminderr.png',
                                width: 30,
                                height: 30,
                              ),
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
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                'assets/icons/pet-care.png',
                                width: 30,
                                height: 30,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/petSitters');
                              },
                            ),
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
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                'assets/icons/sad.png',
                                width: 30,
                                height: 30,
                              ),
                              onPressed: () {
                                // Add your onPressed logic here
                              },
                            ),
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
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                'assets/icons/more.png',
                                width: 30,
                                height: 30,
                              ),
                              onPressed: () {
                                // Add your onPressed logic here
                              },
                            ),
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
          ],
        ),
      ),
    );
  }
}
