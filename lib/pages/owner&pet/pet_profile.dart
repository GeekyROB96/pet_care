import 'dart:io';

import 'package:flutter/material.dart';
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
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                color: Colors.white,
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
                              // Pet Name and Energy
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          pet['petName'] ?? 'N/A',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 8),
                                        EnergyBarWithIcon(
                                          energyLevel:
                                              pet['energyLevel'] ?? 'low',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      pet['breed'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              // Pet Type Image
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
                          SizedBox(height: 20),
                          // Info Cards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(
                                colors: Color.fromARGB(255, 250, 223, 187),
                                title: 'Age',
                                titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: '${pet['age']} years',
                                contentTextStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121),
                                ),
                              ),
                              InfoCard(
                                colors: Color.fromARGB(255, 197, 251, 199),
                                title: 'Gender',
                                titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: '${pet['gender']}',
                                contentTextStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121),
                                ),
                              ),
                              InfoCard(
                                colors: Color.fromARGB(255, 191, 225, 249),
                                title: 'Weight',
                                titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: pet['weight'] != null
                                    ? '${pet['weight']} kg'
                                    : 'N/A',
                                contentTextStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 121, 121, 121),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Attributes
                          Row(
                            children: [
                              Text(
                                'Attributes: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (pet['friendlyWithChildren'] == false &&
                                  pet['friendlyWithOtherPets'] == false)
                                Text(
                                  'N/A',
                                  style: TextStyle(color: Colors.black),
                                )
                            ],
                          ),
                          SizedBox(height: 10),
                          // Additional Attributes
                          Row(
                            children: [
                              if (pet['friendlyWithChildren'] == true)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Color.fromARGB(255, 176, 147, 255),
                                  ),
                                  child: Text(
                                    'Children Friendly',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              if (pet['friendlyWithOtherPets'] == true)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Color.fromARGB(255, 255, 235, 147),
                                  ),
                                  child: Text(
                                    'Pet Friendly',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              if (pet['houseTrained'])
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Color.fromARGB(255, 255, 235, 147),
                                  ),
                                  child: Text(
                                    'House Trained',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Feeding Schedule
                          Text(
                            'Feeding Schedule',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
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
                          // About Pet
                          Text(
                            'About Pet',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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

class EnergyBarWithIcon extends StatelessWidget {
  final String energyLevel;

  EnergyBarWithIcon({required this.energyLevel});

  @override
  Widget build(BuildContext context) {
    Color barColor;
    switch (energyLevel) {
      case 'low':
        barColor = Colors.red;
        break;
      case 'medium':
        barColor = Colors.orange;
        break;
      case 'high':
        barColor = Colors.green;
        break;
      default:
        barColor = Colors.grey;
        break;
    }

    return Row(
      children: [
        // Energy Icon
        Image.asset(
          'assets/icons/energy.png',
          height: 30,
          width: 30,
        ),
        SizedBox(width: 5),
        // Energy Bar
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: barColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            energyLevel.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
