import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/provider/volunteer_provider/volunteer_reg_provider.dart';
import 'package:pet_care/widgets/components/text_button.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';

class VolunteerReg extends StatelessWidget {
  final _volunteerNameController = TextEditingController();
  final _volunteerEmailController = TextEditingController();
  final _volunteerPasswordController = TextEditingController();
  final _volunteerPhoneNoController = TextEditingController();
  final _volunteerAgeController = TextEditingController();
  final _volunteerOccupationController = TextEditingController();
  final __volunteerCityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15),
            Image.asset(
              'assets/images/landing-2.png',
              height: 120,
              width: 120,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: LightColors.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Consumer<VolunteerRegistrationProvider>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextField(
                              hintText: 'Name',
                              obsText: false,
                              controller: _volunteerNameController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.person),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Email',
                              obsText: false,
                              controller: _volunteerEmailController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.email_outlined),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Password',
                              obsText: !provider.isPasswordVisible,
                              controller: _volunteerPasswordController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              focusNode: FocusNode(),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: ImageIcon(
                                  AssetImage(provider.isPasswordVisible
                                      ? 'assets/images/pet-icon.png'
                                      : 'assets/images/pet-icon.png'),
                                ),
                                onPressed: () {
                                  provider.toggleVolunteerPasswordVisibility();
                                },
                              ),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Phone No',
                              obsText: false,
                              controller: _volunteerPhoneNoController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.phone),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Age',
                              obsText: false,
                              controller: _volunteerAgeController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.calendar_today),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Occupation (Optional)',
                              obsText: false,
                              controller: _volunteerOccupationController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.work_outline),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'City (Optional)',
                              obsText: false,
                              controller: __volunteerCityController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.location_city_outlined),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            SizedBox(height: 5),
                            CustomTextButton(
                              onPressed: () {
                                provider.setVolunteerName(
                                    _volunteerNameController.text);
                                provider.setVolunteerEmail(
                                    _volunteerEmailController.text);
                                provider.setVolunteerPassword(
                                    _volunteerPasswordController.text);
                                provider.setVolunteerPhoneNo(
                                    _volunteerPhoneNoController.text);
                                provider.setVolunteerAge(
                                    _volunteerAgeController.text);
                                provider.setVolunteerOccupation(
                                    _volunteerOccupationController.text);
                                provider.setLocationCity(
                                    __volunteerCityController.text);
                                provider.navigateToVolunteerReg2(context);
                              },
                              text: 'Next',
                              backgroundColor: LightColors.primaryDarkColor,
                              textColor: LightColors.textColor,
                              fontSize: 15,
                              width: 100,
                            ),
                            SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account?',
                                style: TextStyle(
                                  color: LightColors.textColor,
                                  fontSize: 16,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: ' '),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        provider
                                            .navigateToVolunteerLogin(context);
                                      },
                                  )
                                ],
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
          ],
        ),
      ),
    );
  }
}
