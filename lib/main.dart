import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/theme_provider.dart';
import 'package:pet_care/firebase_options.dart';
import 'package:pet_care/initial_screen.dart';
import 'package:pet_care/pages/booking/booking_page.dart';
import 'package:pet_care/pages/owner&pet/owner_editprofile.dart';
import 'package:pet_care/pages/owner&pet/owner_homescreen.dart';
import 'package:pet_care/pages/owner&pet/owner_login.dart';
import 'package:pet_care/pages/owner&pet/owner_signup.dart';
import 'package:pet_care/pages/owner&pet/pet_profile.dart';
import 'package:pet_care/pages/owner&pet/pet_register.dart';
import 'package:pet_care/pages/owner&pet/pet_register2.dart';
import 'package:pet_care/pages/pets_page/pets.dart';
import 'package:pet_care/pages/screens/lost_pet_address_screen.dart';
import 'package:pet_care/pages/screens/pet_lost_page.dart';
import 'package:pet_care/pages/screens/pet_sitters.dart';
import 'package:pet_care/pages/volunteer/booking_details_show.dart';
import 'package:pet_care/pages/volunteer/volSide_pet_profile.dart';
import 'package:pet_care/pages/volunteer/volunteer_editProfile.dart';
import 'package:pet_care/pages/volunteer/volunteer_homescreen.dart';
import 'package:pet_care/pages/volunteer/volunteer_login_page.dart';
import 'package:pet_care/pages/volunteer/volunteer_reg.dart';
import 'package:pet_care/pages/volunteer/volunter_reg2.dart';
import 'package:pet_care/provider/bookind_details_provider.dart';
import 'package:pet_care/provider/booking_details_getter.dart';
import 'package:pet_care/provider/forgot_password_provider.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:pet_care/provider/lost_pet_provider.dart';
import 'package:pet_care/provider/owner_dashboard_provider.dart';
import 'package:pet_care/provider/owner_editprofile_provider.dart';
import 'package:pet_care/provider/owner_login_provider.dart';
import 'package:pet_care/provider/owner_reg_provider.dart';
import 'package:pet_care/provider/payment_page_provider.dart';
import 'package:pet_care/provider/pet_reg_provider.dart';
import 'package:pet_care/provider/pet_sitter_provider.dart';
import 'package:pet_care/provider/pets_provider.dart';
import 'package:pet_care/provider/register_provider.dart';
import 'package:pet_care/provider/reminder_provider.dart';
import 'package:pet_care/provider/volunteer_login_provider.dart';
import 'package:pet_care/provider/volunteer_reg_provider.dart';
import 'package:pet_care/shared_pref_service.dart';
import 'package:pet_care/widgets/forgot_screen.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Zego UIKit and set navigator key
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    final prefsService = SharedPreferencesService();
    prefsService.init().then((_) {
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
            ChangeNotifierProvider(
                create: (context) => VolunteerLoginProvider()),
            ChangeNotifierProvider(
                create: (context) => ForgotPasswordProvider()),
            ChangeNotifierProvider(
                create: (context) => OwnerDetailsGetterProvider()),
            ChangeNotifierProvider(create: (context) => PetsProvider()),
            ChangeNotifierProvider(
                create: (context) => PetRegistrationProvider()),
            ChangeNotifierProvider(
                create: (context) => PetsDetailsGetterProvider()),
            ChangeNotifierProvider(
                create: (context) => OwnerDashboardProvider()),
            ChangeNotifierProvider(
                create: (context) => OwnerEditProfileProvider()),
            ChangeNotifierProvider(
                create: (context) => VolunteerDetailsGetterProvider()),
            ChangeNotifierProvider(create: (context) => PetSitterProvider()),
            ChangeNotifierProvider(create: (context) => ReminderProvider()),
            ChangeNotifierProvider(
                create: (context) => BookingDetailsProvider()),
            ChangeNotifierProvider(create: (context) => PaymentPageProvider()),
            ChangeNotifierProvider(
                create: (context) => BookingDetailsGetterProvider()),
            ChangeNotifierProvider(create: (context) => LostPetProvider())
          ],
          child: MyApp(),
        ),
      );
    });
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        '/petProfile': (context) => PetProfile(),
        '/bookingPage': (context) => BookingDetailsPage(),
        '/bookingDetailsShow': (context) => BookingDetailsShow(),
        '/petProfile2': (context) => PetProfile2(),
        '/lostPetAddress': (context) => PetLostAddress(),
         '/lostPet': (context) => PetLost(),
      },
    );
  }
}
