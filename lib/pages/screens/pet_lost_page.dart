import 'dart:io'; // For File
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_care/constants/custom_toast.dart';
import 'package:pet_care/pages/screens/lost_pet_address_screen.dart';
import 'package:pet_care/services/firestore_service/lost_pet_firestore.dart';
import 'package:provider/provider.dart';

import '../../provider/lost_pet_provider.dart';
import '../../provider/owner_provider/get_ownerData_provider.dart';

class PetLost extends StatefulWidget {
  const PetLost({Key? key}) : super(key: key);

  @override
  State<PetLost> createState() => _PetLostState();
}

class _PetLostState extends State<PetLost> {
  OwnerDetailsGetterProvider ownerDetailsProvider =
      OwnerDetailsGetterProvider();

  @override
  void initState() {
    super.initState();
    ownerDetailsProvider.loadUserProfile();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    try {
      List<Map<String, dynamic>> pets = await ownerDetailsProvider.getPets();
      setState(() {
        petList = pets.map((pet) => pet['petName'] as String).toList();
      });
    } catch (e) {
      print("Error fetching pets: $e");
    }
  }

  List<String> petList = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LostPetProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lost Your Pet'),
          centerTitle: true,
        ),
        body: Consumer<LostPetProvider>(
          builder: (context, lostPetProvider, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Report Your Lost Pet',
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  speed: Duration(milliseconds: 200),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Fill in the details below to report your lost pet.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Select Pet Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Your Pet',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: lostPetProvider.selectedPet,
                        onChanged: (value) {
                          lostPetProvider.selectedPet = value;
                        },
                        items: petList.map((pet) {
                          return DropdownMenuItem<String>(
                            value: pet,
                            child: Text(pet),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Select a pet',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Upload a recent picture',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                lostPetProvider.image = File(pickedFile.path);
                              }
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  lostPetProvider.petImageFile != null
                                      ? FileImage(lostPetProvider.petImageFile!)
                                      : null,
                              child: lostPetProvider.petImageFile == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Last Seen Date and Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Seen',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            TimeOfDay? timePicked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (timePicked != null) {
                              lostPetProvider.selectedDateTime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                timePicked.hour,
                                timePicked.minute,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lostPetProvider.selectedDateTime == null
                                    ? 'Select Date and Time'
                                    : DateFormat('MMM dd, yyyy - hh:mm a')
                                        .format(
                                            lostPetProvider.selectedDateTime!),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        maxLines: 4,
                        onChanged: (value) {
                          lostPetProvider.description = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText:
                              'Provide the details of your pet & where you have lost',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // navigateToAddress();
                      Navigator.pushNamed(context, '/lostPetAddress');
                    },
                    child: Row(children: [
                      Text(
                        'Locate your Pet',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                    ]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await lostPetProvider.saveLostPet(context);
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
