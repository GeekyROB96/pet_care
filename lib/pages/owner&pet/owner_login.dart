import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/widgets/components/text_button.dart';
import 'package:pet_care/widgets/components/textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';
import '../../provider/owner_login_provider.dart';

class OwnerLogin extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/images/kutta.png',
              height: 150,
              width: 100,
              // fit: BoxFit.cover,
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
                  child: Consumer<OwnerLoginProvider>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              obsText: !provider.isOwnerPasswordVisible,
                              controller: _passwordController,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.zero,
                              focusNode: FocusNode(),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: ImageIcon(
                                  AssetImage(provider.isOwnerPasswordVisible
                                      ? 'assets/images/pet-icon.png'
                                      : 'assets/images/pet-icon.png'),
                                ),
                                onPressed: () {
                                  provider.toggleOwnerPasswordVisibility();
                                },
                              ),
                              textStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  provider.navigateToForgotPassword(context);
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: LightColors.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            provider.isLoading
                                ? CircularProgressIndicator()
                                : CustomTextButton(
                                    onPressed: () {
                                      provider
                                          .setOwnerEmail(_emailController.text);
                                      provider.setOwnerPassword(
                                          _passwordController.text);
                                      provider.ownerLogin(context);
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
                                style: const TextStyle(
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
                                      color: LightColors.textColor,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, '/ownerReg');
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
