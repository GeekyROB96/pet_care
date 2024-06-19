import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:provider/provider.dart';

class PetProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PetsDetailsGetterProvider>(
        builder: (context, petsDetailsProvider, child) {
          if (!petsDetailsProvider.isSinglePetLoaded) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final pet = petsDetailsProvider.petData;
          final imagePath = pet['imagePath'];
          final isNetworkImage =
              Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;

          return Stack(
            children: [
              // Background Image Container
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                color: Colors.grey[200],
                child: imagePath != null
                    ? (isNetworkImage
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/cat.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/cat.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ))
                    : Image.asset(
                        'assets/images/cat.png',
                        fit: BoxFit.cover,
                      ),
              ),

              // Content Container
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button Container
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Pet Details Container
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, -2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pet['petName'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle overflow if petName is too long
                                ),
                              ),
                              if (pet['energyLevel'] == 'low')
                                EnergyLevelIndicator(energyLevel: 'low'),
                              if (pet['energyLevel'] == 'medium')
                                EnergyLevelIndicator(energyLevel: 'medium'),
                              if (pet['energyLevel'] == 'high')
                                EnergyLevelIndicator(energyLevel: 'high'),
                              SizedBox(
                                  width: 16), // Adjust the spacing as needed
                              if (pet['selectedPetType'] == 'Dog')
                                Image.asset(
                                  'assets/images/dog_face.png',
                                  height: 50,
                                  width: 50,
                                ),
                              if (pet['selectedPetType'] == 'Cat')
                                Image.asset(
                                  'assets/images/cat_face.png',
                                  height: 50,
                                  width: 50,
                                ),
                              if (pet['selectedPetType'] == 'Bird')
                                Image.asset(
                                  'assets/images/bird_face.png',
                                  height: 50,
                                  width: 50,
                                ),
                              if (pet['selectedPetType'] == 'Rabbit')
                                Image.asset(
                                  'assets/images/rabbit_face.png',
                                  height: 50,
                                  width: 50,
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            pet['breed'] ?? 'N/A',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(
                                colors: Color.fromARGB(255, 250, 223, 187),
                                title: 'Age',
                                titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                content: '${pet['age']} years',
                                contentTextStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121)),
                              ),
                              InfoCard(
                                colors: Color.fromARGB(255, 197, 251, 199),
                                title: '${pet['gender']}',
                                titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                content: 'sex',
                                contentTextStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121)),
                              ),
                              InfoCard(
                                colors: Color.fromARGB(255, 191, 225, 249),
                                title: 'Weight',
                                titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                content: pet['weight'] != null
                                    ? '${pet['weight']} kg'
                                    : 'N/A',
                                contentTextStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121)),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(children: [
                            Text(
                              'Attributes: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (pet['friendlyWithChildren'] == false &&
                                pet['friendlyWithOtherPets'] == false)
                              Text(
                                'N/A',
                                style: TextStyle(color: Colors.black),
                              )
                          ]),
                          if (pet['friendlyWithChildren'] == true ||
                              pet['friendlyWithOtherPets'] == true)
                            SizedBox(height: 10),
                          Row(
                            children: [
                              if (pet['friendlyWithChildren'] == true)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color:
                                          Color.fromARGB(255, 176, 147, 255)),
                                  child: Text(
                                    'Children Friendly',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              SizedBox(width: 8),
                              if (pet['friendlyWithOtherPets'] == true)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color:
                                          Color.fromARGB(255, 255, 235, 147)),
                                  child: Text(
                                    'Pet Friendly',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              SizedBox(width: 8),
                              if (pet['houseTrained'])
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color:
                                          Color.fromARGB(255, 255, 235, 147)),
                                  child: Text(
                                    'House Trained',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Feeding Schedule',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                pet['feedingSchedule'] != ''
                                    ? pet['feedingSchedule']
                                    : 'N/A',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'About Pet',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              pet['aboutPet'] ?? 'N/A',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final Color? colors;

  InfoCard({
    required this.title,
    required this.content,
    this.titleTextStyle,
    this.contentTextStyle,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 93,
      height: 93,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: titleTextStyle ??
                TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 5),
          Text(
            content,
            style: contentTextStyle ?? TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class EnergyLevelIndicator extends StatelessWidget {
  final String energyLevel;

  EnergyLevelIndicator({required this.energyLevel});

  @override
  Widget build(BuildContext context) {
    double height = 30.0;
    Color color;
    double widthFactor;

    switch (energyLevel.toLowerCase()) {
      case 'high':
        color = Colors.green;
        widthFactor = 5.0; // Full width
        break;
      case 'medium':
        color = Colors.orange;
        widthFactor = 2.5; // Half width
        break;
      case 'low':
        color = Colors.red;
        widthFactor = 1.25; // Quarter width
        break;
      default:
        color = Colors.grey;
        widthFactor = 0.0; // No width
    }

    return Container(
      width: 50, // Set a fixed width for the indicator
      height: height,
      color: Colors.grey[300], // Background bar color
      child: SizedBox(
        // alignment: Alignment.centerLeft,
        width: widthFactor,
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
