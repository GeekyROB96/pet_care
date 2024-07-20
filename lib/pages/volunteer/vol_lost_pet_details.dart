import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_care/pages/volunteer/vol_lostpet_address_update.dart';
import 'package:pet_care/provider/volunteer_provider/vol_lostpet_show_details_provider.dart';
import 'package:provider/provider.dart';

class VolLostPetDetail extends StatefulWidget {
  final String petId;

  const VolLostPetDetail({Key? key, required this.petId}) : super(key: key);

  @override
  _VolLostPetDetailState createState() => _VolLostPetDetailState();
}

class _VolLostPetDetailState extends State<VolLostPetDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VolLostPetShowDetailsProvider>(context, listen: false)
          .loadPetDataByPetId(widget.petId)
          .then((_) {
        Provider.of<VolLostPetShowDetailsProvider>(context, listen: false)
            .getPetData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VolLostPetShowDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.lostPetData == null || provider.pet == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            var pet = provider.pet!;
            var petData = provider.lostPetData!;
            var imagePath = petData['petImageUrl'];
            bool isNetworkImage =
                imagePath != null && imagePath.startsWith('http');

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121),
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
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121),
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
                                    color: const Color.fromARGB(
                                        255, 121, 121, 121),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Pet Description and Address Container
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    petData['description'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Area, Apartment, Road: ${petData['address']['area_apartment_road'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'City: ${petData['address']['city'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Description Directions: ${petData['address']['description_directions'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Main: ${petData['address']['main'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Pincode: ${petData['address']['pincode'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'State: ${petData['address']['state'] ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Map Location',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                            SizedBox(
                              height: 15,
                            ),

                            PetLocationMap(
                              latitude: double.parse(petData['address']
                                      ['coordinates']
                                  .split(',')[0]),
                              longitude: double.parse(petData['address']
                                      ['coordinates']
                                  .split(',')[1]),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          Row(
                            children: [
                              OutlinedButton(
                                  onPressed: () {},
                                  child: Text('Chat with Owner')),
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VolLostPetAddressUpdate(
                                                petId: petData['petId'],
                                              )),
                                    );
                                  },
                                  child: Text('Update Address'))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
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

class PetLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  PetLocationMap({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId('pet_location'),
              position: LatLng(latitude, longitude),
            ),
          },
        ),
      ),
    );
  }
}
