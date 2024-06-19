import 'package:flutter/material.dart';
import 'package:pet_care/widgets/components/tooltips.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';
import '../../provider/pet_reg_provider.dart';
import '../../widgets/components/text_button.dart';

class PetRegistration2 extends StatelessWidget {
  final TextEditingController _feedingScheduleController =
      TextEditingController();
  final TextEditingController _aboutPetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: LightColors.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Consumer<PetRegistrationProvider>(
                      builder: (context, provider, child) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Additional Info Header
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 8.0, left: 8.0),
                                    child: Text(
                                      'Additional Info',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  CustomToolTip(
                                    message: 'Hello Information',
                                    // additionalInfo: 'Additional Information',
                                  ),
                                ],
                              ),
                              // Switch List Tiles
                              Card(
                                color: LightColors.backgroundColor,
                                elevation: 5.0,
                                child: SwitchListTile(
                                  title: Text('Friendly with Children'),
                                  value: provider.friendlyWithChildren,
                                  onChanged: (value) {
                                    provider.setFriendlyWithChildren(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 5),
                              Card(
                                color: LightColors.backgroundColor,
                                elevation: 5.0,
                                child: SwitchListTile(
                                  title: Text('Friendly with Other Pets'),
                                  value: provider.friendlyWithOtherPets,
                                  onChanged: (value) {
                                    provider.setFriendlyWithOtherPets(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 5),
                              Card(
                                color: LightColors.backgroundColor,
                                elevation: 5.0,
                                child: SwitchListTile(
                                  title: Text('House Trained'),
                                  value: provider.houseTrained,
                                  onChanged: (value) {
                                    provider.setHouseTrained(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 5),
                              Card(
                                color: LightColors.backgroundColor,
                                elevation: 5.0,
                                child: SwitchListTile(
                                  title: Text('Can be Left Alone'),
                                  value: provider.canBeLeftAlone,
                                  onChanged: (value) {
                                    provider.setCanBeLeftAlone(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              // Care Info Header
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 8.0, left: 8.0),
                                    child: Text(
                                      'Care Info',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 8.0, right: 8.0),
                                    child: const Icon(Icons.info_outlined),
                                  ),
                                ],
                              ),
                              // Walks per Day
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Walks per Day',
                                      style: TextStyle(color: Colors.black)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (provider.walksPerDay > 0) {
                                            provider.setWalksPerDay(
                                                provider.walksPerDay - 1);
                                          }
                                        },
                                      ),
                                      Text(
                                        provider.walksPerDay.toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          provider.setWalksPerDay(
                                              provider.walksPerDay + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Energy Level
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Energy Level',
                                      style: TextStyle(color: Colors.black)),
                                  DropdownButton<String>(
                                    hint: Text('Energy Level'),
                                    value: provider.energyLevel,
                                    items: ['Low', 'Medium', 'High']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      provider.setEnergyLevel(newValue!);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              // Feeding Schedule
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Feeding Schedule',
                                      style: TextStyle(color: Colors.black)),
                                  DropdownButton<String>(
                                    hint: Text('Feeding Schedule'),
                                    value: provider.feedingSchedule,
                                    items: [
                                      'Once a day',
                                      'Twice a day',
                                      'Thrice a day',
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      provider.setFeedingSchedule(newValue!);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              TextFormField(
                                // minLines: 3,

                                autofocus: true,
                                controller: _aboutPetController,
                                decoration: InputDecoration(
                                  hintText: "About your pet",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          new Radius.circular(20.0))),
                                ),
                                onChanged: (_aboutPetController) =>
                                    provider.setAboutPet(_aboutPetController),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: provider.isLoading
                                    ? CircularProgressIndicator()
                                    : CustomTextButton(
                                        onPressed: () async {
                                          await provider.registerPet(context);
                                        },
                                        text: 'Register Pet',
                                        backgroundColor:
                                            LightColors.primaryDarkColor,
                                        textColor: LightColors.textColor,
                                        fontSize: 15,
                                        width: 150,
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
