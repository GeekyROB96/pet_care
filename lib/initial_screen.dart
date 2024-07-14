import 'package:flutter/material.dart';
import 'package:pet_care/pages/owner&pet/owner_homescreen.dart';
import 'package:pet_care/pages/volunteer/volunteer_homescreen.dart';
import 'package:pet_care/provider/owner_provider/owner_login_provider.dart';
import 'package:pet_care/provider/volunteer_provider/volunteer_login_provider.dart';
import 'package:pet_care/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerLoginProvider>(context);
    final volunteerProvider = Provider.of<VolunteerLoginProvider>(context);

    return FutureBuilder(
      future: Future.wait([
        ownerProvider.checkOwnerLoginStatus(),
        volunteerProvider.checkVolunteerLoginStatus(),
      ]),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading login status'));
        } else {
          if (ownerProvider.isOwnerLoggedIn) {
            return OwnerDashboard();
          } else if (volunteerProvider.isVolunteerLoggedIn) {
            return VolunteerDashboard();
          } else {
            return SplashScreen();
          }
        }
      },
    );
  }
}
