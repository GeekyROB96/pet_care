import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/widgets/components/text_button.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';
import '../../provider/volunteer_login_provider.dart';

class VolunteerLogin extends StatelessWidget {
  final _volunteerEmailController = TextEditingController();
  final _volunteerPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15),
            Image.asset(
              'assets/images/pet-human.png',
              height: 250,
              width: 100,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: LightColors.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Consumer<VolunteerLoginProvider>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              obsText: !provider.isVolunteerPasswordVisible,
                              controller: _volunteerPasswordController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              focusNode: FocusNode(),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: ImageIcon(
                                  AssetImage(provider.isVolunteerPasswordVisible
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
                            SizedBox(height: 5),
                            provider.isLoading
                                ? CircularProgressIndicator()
                                : CustomTextButton(
                                    onPressed: () {
                                      provider.setVolunteerEmail(
                                          _volunteerEmailController.text);
                                      provider.setVolunteerPassword(
                                          _volunteerPasswordController.text);
                                      provider.volunteerLogin(context);
                                    },
                                    text: 'Sign In',
                                    backgroundColor:
                                        LightColors.primaryDarkColor,
                                    textColor: LightColors.textColor,
                                    fontSize: 15,
                                    width: 100,
                                  ),
                            SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ',
                                    ),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          provider
                                              .navigateToVolunteerReg(context);
                                        },
                                    )
                                  ]),
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
