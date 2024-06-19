import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_care/provider/pets_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';
import '../../provider/pet_reg_provider.dart';
import '../../widgets/components/text_button.dart';
import '../../widgets/components/textfield.dart';

class PetRegistration extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedPetType = Provider.of<PetsProvider>(context).selectedPetType;

    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                'Register Your $selectedPetType',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: LightColors.backgroundColor,
                                  backgroundImage: provider.image != null
                                      ? FileImage(File(provider.image!.path))
                                      : null,
                                  child: provider.image == null
                                      ? const Icon(
                                          Icons.pets,
                                          color: LightColors.textColor,
                                          size: 60,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: LightColors.textColor,
                                    ),
                                    onPressed: () {
                                      provider.pickProfileImage(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            MyTextField(
                              hintText: 'Pet Name',
                              obsText: false,
                              controller: _nameController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              textStyle:
                                  TextStyle(color: LightColors.textColor),
                              fillColor: LightColors.backgroundColor,
                            ),
                            MyTextField(
                              hintText: 'Breed',
                              obsText: false,
                              controller: _breedController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              textStyle:
                                  TextStyle(color: LightColors.textColor),
                              fillColor: LightColors.backgroundColor,
                            ),
                            MyTextField(
                              hintText: 'Age',
                              obsText: false,
                              controller: _ageController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              textStyle:
                                  TextStyle(color: LightColors.textColor),
                              fillColor: LightColors.backgroundColor,
                            ),
                             SizedBox(height: 15),
                            MyTextField(
                              hintText: 'Weight (kgs)',
                              obsText: false,
                              controller: _weightController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              textStyle:
                                  TextStyle(color: LightColors.textColor),
                              fillColor: LightColors.backgroundColor,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  provider.setPetweight(int.parse(value));
                                }
                              },
                            ),
                            DropdownButton<String>(
                              hint: Text("Select Gender"),
                              value: provider.gender,
                              items: ['Male', 'Female'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                provider.setGender(newValue!);
                              },
                            ),
                           
                            SizedBox(height: 20),

                            CustomTextButton(
                              onPressed: () {
                                provider.setPetName(_nameController.text);
                                provider.setBreed(_breedController.text);
                                provider.setAge(_ageController.text);
                                // provider.setWeight(_weightController.text);
                                provider.navigateToPetRegistration2(context);
                              },
                              text: 'Next',
                              backgroundColor: LightColors.primaryDarkColor,
                              textColor: LightColors.textColor,
                              fontSize: 15,
                              width: 100,
                            ),
                          ],
                        ),
                      );
                    },
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
