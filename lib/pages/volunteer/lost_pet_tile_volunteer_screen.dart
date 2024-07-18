import 'package:flutter/material.dart';
import 'package:pet_care/provider/volunteer_provider/lostpet_details_getter_provider.dart';
import 'package:provider/provider.dart';

class LostPetShowVolunteer extends StatelessWidget {
  const LostPetShowVolunteer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<LostPetDetailsGetterVolunteer>(context, listen: false)
            .loadData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return Consumer<LostPetDetailsGetterVolunteer>(
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
                            'Help Lost Pets',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 45),
                          Tooltip(
                            message:
                                'These pets are lost from their owner. If possible please help!',
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
                            return _buildPetCard(pet);
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                petImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      breed ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      selectedPetType?? '',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 15, 15, 15),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),

                  SizedBox(height: 8),
                  Text(
                    'Last Seen: $lastSeen',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Distance: $distance', // Display the calculated distance
                    style: TextStyle(color: Colors.grey[600]),
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
