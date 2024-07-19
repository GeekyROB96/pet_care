import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/owner_provider/owner_lostpet_show_details_provider.dart';
import '../volunteer/volSide_pet_profile.dart';

class OwnerLostPetDetail extends StatefulWidget {
  final String petId;

  const OwnerLostPetDetail({Key? key, required this.petId}) : super(key: key);

  @override
  _OwnerLostPetDetailState createState() => _OwnerLostPetDetailState();
}

class _OwnerLostPetDetailState extends State<OwnerLostPetDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OwnerLostPetShowDetailsProvider>(context, listen: false)
          .loadPetDataByPetId(widget.petId)
          .then((_) {
        Provider.of<OwnerLostPetShowDetailsProvider>(context, listen: false)
            .getPetData();
      });
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hurray!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OwnerLostPetShowDetailsProvider>(
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
                            // Last Seen and Address Container
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
                                    'Last Seen',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    petData['lastSeen'] ?? 'N/A',
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
                            SizedBox(height: 20),
                            // Action Button
                            Center(
                              child: ElevatedButton(
                                onPressed: _showSuccessMessage,
                                child: Text('Have Found My Pet!'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Colors.deepPurpleAccent, // Text color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
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
