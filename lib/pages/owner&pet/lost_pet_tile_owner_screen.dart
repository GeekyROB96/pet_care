import 'package:flutter/material.dart';
import 'package:pet_care/provider/owner_provider/lostpet_details_getter_provider.dart';
import 'package:provider/provider.dart';

import 'owner_lost_pet_details.dart';

class LostPetShowOwner extends StatelessWidget {
  const LostPetShowOwner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<LostPetDetailsGetterOwner>(context, listen: false)
            .loadData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return Consumer<LostPetDetailsGetterOwner>(
              builder: (context, lostPetDetailsGetter, child) {
                if (lostPetDetailsGetter.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> allLostPets =
                    lostPetDetailsGetter.allLostPets;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back)),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Your Lost Pets',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 45),
                          Tooltip(
                            message: 'Know about your lost pets',
                            child: Image.asset(
                              'assets/icons/question_mark.png',
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: allLostPets.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> pet = allLostPets[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OwnerLostPetDetail(
                                            petId: pet['petId'],
                                          )),
                                );
                              },
                              child: _buildPetCard(pet),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    String petImageUrl = pet['petImageUrl'];
    String petName = pet['petName'];
    String? lastSeen = pet['lastSeen'];
    String? distance = pet['distance'];
    String? breed = pet['breed'];
    String? selectedPetType = pet['selectedPetType'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(petImageUrl),
              radius: 40,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        petName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            lastSeen ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Breed: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        breed ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 16),
                      _getPetIcon(selectedPetType ?? ''),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        distance ?? '',
                        style: TextStyle(color: Colors.grey[600]),
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

  Widget _getPetIcon(String petType) {
    String petIconPath = '';
    switch (petType.toLowerCase()) {
      case 'dog':
        petIconPath = 'assets/icons/dog.png';
        break;
      case 'cat':
        petIconPath = 'assets/icons/cat.png';
        break;
      case 'bird':
        petIconPath = 'assets/icons/bird.png';
        break;
      case 'rabbit':
        petIconPath = 'assets/icons/bunny.png';
        break;
      default:
        return SizedBox.shrink();
    }
    return Image.asset(
      petIconPath,
      height: 24,
      width: 24,
    );
  }
}
