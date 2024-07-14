import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/widgets/components/text_button.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';
import '../../provider/owner_provider/owner_reg_provider.dart';

class OwnerReg extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/images/pe.png',
              height: 100,
              width: 90,
              // fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: LightColors.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Consumer<OwnerRegistrationProvider>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyTextField(
                              hintText: 'Name',
                              obsText: false,
                              controller: _nameController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.person),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Email',
                              obsText: false,
                              controller: _emailController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.email_outlined),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Password',
                              obsText: !provider.isPasswordVisible,
                              controller: _passwordController,
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
                                  provider.togglePasswordVisibility();
                                },
                              ),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Phone No',
                              obsText: false,
                              controller: _phoneNoController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.phone),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Age',
                              obsText: false,
                              controller: _ageController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.calendar_month),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'Occupation (Optional)',
                              obsText: false,
                              controller: _occupationController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon:
                                  Icon(Icons.miscellaneous_services_outlined),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            MyTextField(
                              hintText: 'City (Optional)',
                              obsText: false,
                              controller: _locationController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              prefixIcon: Icon(Icons.location_city_outlined),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            SizedBox(height: 5),
                            provider.isLoading
                                ? CircularProgressIndicator()
                                : CustomTextButton(
                                    onPressed: () async {
                                      provider.setName(_nameController.text);
                                      provider.setEmail(_emailController.text);
                                      provider.setPassword(
                                          _passwordController.text);
                                      provider
                                          .setPhoneNo(_phoneNoController.text);
                                      provider.setAge(_ageController.text);
                                      provider.setOccupation(
                                          _occupationController.text);
                                      provider.setLocationCity(
                                          _locationController.text);
                                      await provider.signUp(context);
                                      // Navigator.pushNamed(context, '/pets');
                                    },
                                    text: 'Sign Up',
                                    backgroundColor:
                                        LightColors.primaryDarkColor,
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
                                    TextSpan(
                                      text: ' ',
                                    ),
                                    TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                          fontSize: 14,
                                          //color:
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            provider
                                                .navigateToOwnerLogin(context);
                                          })
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
