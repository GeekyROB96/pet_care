import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/theme_provider.dart';
import 'package:pet_care/firebase_options.dart';
import 'package:pet_care/initial_screen.dart';
import 'package:pet_care/pages/owner&pet/owner_editprofile.dart';
import 'package:pet_care/pages/owner&pet/owner_login.dart';
import 'package:pet_care/pages/owner&pet/owner_signup.dart';
import 'package:pet_care/pages/owner&pet/pet_profile.dart';
import 'package:pet_care/pages/owner&pet/pet_register.dart';
import 'package:pet_care/pages/owner&pet/pet_register2.dart';
import 'package:pet_care/pages/pets_page/pets.dart';
import 'package:pet_care/pages/screens/owner_homescreen.dart';
import 'package:pet_care/pages/screens/pet_sitters.dart';
import 'package:pet_care/pages/screens/volunteer_homescreen.dart';
import 'package:pet_care/pages/volunteer/volunteer_editProfile.dart';
import 'package:pet_care/pages/volunteer/volunteer_login_page.dart';
import 'package:pet_care/pages/volunteer/volunteer_reg.dart';
import 'package:pet_care/pages/volunteer/volunter_reg2.dart';
import 'package:pet_care/provider/forgot_password_provider.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:pet_care/provider/owner_dashboard_provider.dart';
import 'package:pet_care/provider/owner_editprofile_provider.dart';
import 'package:pet_care/provider/owner_login_provider.dart';
import 'package:pet_care/provider/owner_reg_provider.dart';
import 'package:pet_care/provider/pet_reg_provider.dart';
import 'package:pet_care/provider/pet_sitter_provider.dart';
import 'package:pet_care/provider/pets_provider.dart';
import 'package:pet_care/provider/register_provider.dart';
import 'package:pet_care/provider/reminder_provider.dart';
import 'package:pet_care/provider/volunteer_login_provider.dart';
import 'package:pet_care/provider/volunteer_reg_provider.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:pet_care/widgets/forgot_screen.dart';
import 'package:pet_care/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefsService = SharedPreferencesService();
  await prefsService.init(); //made changes

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => OwnerRegistrationProvider()),

        ChangeNotifierProvider(create: (context) => OwnerLoginProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),

        ChangeNotifierProvider(
            create: (context) => VolunteerRegistrationProvider()),
        ChangeNotifierProvider(create: (context) => VolunteerLoginProvider()),
        ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),
        //  ChangeNotifierProvider(create:  (context) =>OwnerEditProfileProvider()),
        ChangeNotifierProvider(
            create: (context) => OwnerDetailsGetterProvider()),
        ChangeNotifierProvider(create: (context) => PetsProvider()),
        ChangeNotifierProvider(create: (context) => PetRegistrationProvider()),
        ChangeNotifierProvider(
            create: (context) => PetsDetailsGetterProvider()),

        // ChangeNotifierProvider(create: (context) =>OwnerDetailsGetterProvider()),
        ChangeNotifierProvider(create: (context) => OwnerDashboardProvider()),
        ChangeNotifierProvider(create: (context) => OwnerEditProfileProvider()),
        ChangeNotifierProvider(
          create: (context) => VolunteerDetailsGetterProvider(),
        ),

        ChangeNotifierProvider(create: (context) => PetSitterProvider()),

        ChangeNotifierProvider(create: (context) => ReminderProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => InitialScreen(),
        '/splashScreen': (context) => InitialScreen(),
        '/ownerReg': (context) => OwnerReg(),
        '/ownerLogin': (context) => OwnerLogin(),
        '/pets': (context) => Pets(),
        '/petRegister': (context) => PetRegistration(),
        '/volunteerRegister': (context) => VolunteerReg(),
        '/volunteerLogin': (context) => VolunteerLogin(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/volunteerRegister2': (context) => VolunteerRegPage2(),
        '/ownerHomeScreen': (context) => OwnerDashboard(),
        '/volunteerHomeScreen': (context) => VolunteerDashboard(),
        '/petRegistration2': (context) => PetRegistration2(),
        '/ownerEditProfile': (context) => OwnerEditProfilePage(),
        '/volunteerEditProfile': (context) => VolunteerEditProfilePage(),
        '/petSitters': (context) => PetSitters(),
        '/petProfile': (context) => PetProfile()
      },
    );
  }
}
