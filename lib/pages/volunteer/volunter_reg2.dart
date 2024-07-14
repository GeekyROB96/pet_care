import 'package:flutter/material.dart';
import 'package:pet_care/provider/volunteer_provider/volunteer_reg_provider.dart';
import 'package:pet_care/widgets/components/text_button.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';

class VolunteerRegPage2 extends StatelessWidget {
  final _volunteerAboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 2),
            Image.asset(
              'assets/images/landing-2.png',
              height: 100,
              width: 90,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
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
                              hintText: 'About Me',
                              obsText: false,
                              controller: _volunteerAboutMeController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.info_outline),
                              prefixTooltipMessage:
                                  'Let us know more about you',
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 8.0, left: 8.0),
                                  child: Text(
                                    'Preferences',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Tooltip(
                                  message: 'What kind of pet do you prefer?',
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 8.0, right: 8.0),
                                    child: const Icon(Icons.info_outlined),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Cat'),
                                value: provider.prefersCat,
                                onChanged: (bool value) {
                                  provider.setPrefersCat(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Dog'),
                                value: provider.prefersDog,
                                onChanged: (bool value) {
                                  provider.setPrefersDog(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Bird'),
                                value: provider.prefersBird,
                                onChanged: (bool value) {
                                  provider.setPrefersBird(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Rabbit'),
                                value: provider.prefersRabbit,
                                onChanged: (bool value) {
                                  provider.setPrefersRabbit(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Others'),
                                value: provider.prefersOthers,
                                onChanged: (bool value) {
                                  provider.setPrefersOthers(value);
                                },
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8.0),
                                  child: Text(
                                    'Services',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Tooltip(
                                  message: 'What services can you provide?',
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 8.0, right: 16.0),
                                    child: const Icon(Icons.info_outlined),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Home Visits'),
                                value: provider.providesHomeVisits,
                                onChanged: (bool value) {
                                  provider.setProvidesHomeVisits(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('Pet Walking'),
                                value: provider.providesDogWalking,
                                onChanged: (bool value) {
                                  provider.setProvidesDogWalking(value);
                                },
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.9),
                              child: SwitchListTile(
                                title: Text('House Sitting'),
                                value: provider.providesHouseSitting,
                                onChanged: (bool value) {
                                  provider.setProvidesHouseSitting(value);
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            provider.isLoading
                                ? CircularProgressIndicator()
                                : CustomTextButton(
                                    onPressed: () {
                                      provider.setVolunteerAboutMe(
                                          _volunteerAboutMeController.text);
                                      provider.volunteerSignUp(context);
                                    },
                                    text: 'Sign Up',
                                    backgroundColor:
                                        LightColors.primaryDarkColor,
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
