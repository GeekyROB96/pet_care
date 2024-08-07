import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:pet_care/provider/volunteer_provider/get_volunteer_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'volunteer_address_page.dart';

class VolunteerEditProfilePage extends StatelessWidget {
  const VolunteerEditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              child: Image.asset(
                'assets/images/pet-human.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                //color: Color(0xFF5F82F6),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC1D8EF).withOpacity(0.9),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                    offset: Offset(0.0, 0.75),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Consumer<VolunteerDetailsGetterProvider>(
                    builder: (context, volunteerDetailsProvider, child) {
                      return volunteerDetailsProvider.isDataLoaded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            image: DecorationImage(
                                              image: volunteerDetailsProvider
                                                          .imageUrl !=
                                                      null
                                                  ? NetworkImage(
                                                      volunteerDetailsProvider
                                                          .imageUrl!)
                                                  : AssetImage(
                                                          'assets/images/default.png')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () =>
                                                volunteerDetailsProvider
                                                    .pickProfileImage(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          volunteerDetailsProvider.name ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          volunteerDetailsProvider.email ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(
                                        context,
                                        Icons.person_outline,
                                        'Name:',
                                        volunteerDetailsProvider.name ?? '',
                                      ),
                                      SizedBox(height: 16),
                                      _buildDetailRow(
                                        context,
                                        Icons.email_outlined,
                                        'Email Id:',
                                        volunteerDetailsProvider.email ?? '',
                                      ),
                                      SizedBox(height: 16),
                                      _buildDetailRow(
                                        context,
                                        Icons.phone_outlined,
                                        'Phone Number:',
                                        volunteerDetailsProvider.phoneNo ?? '',
                                      ),
                                      SizedBox(height: 16),
                                      _buildDetailRow(
                                        context,
                                        Icons.info_outline,
                                        'About Me:',
                                        volunteerDetailsProvider.aboutMe ?? '',
                                      ),

                                      _buildDetailRow(
                                        context,
                                        Icons.location_on,
                                        'Address:',
                                        volunteerDetailsProvider.city??''
                                         ),

                                      buildAddressDetails(volunteerDetailsProvider),
                                    
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text(
                                            'Services Price:',
                                            style: TextStyle(
                                              color: LightColors.textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'INR',
                                            style: TextStyle(
                                              color: LightColors.textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              readOnly: volunteerDetailsProvider
                                                  .checkHomeVisits(),
                                              decoration: InputDecoration(
                                                labelText: 'Home Visits',
                                                labelStyle: TextStyle(
                                                  color: LightColors.textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                prefixIcon: Icon(Icons.home),
                                              ),
                                              controller: TextEditingController(
                                                text: volunteerDetailsProvider
                                                        .providesHomeVisitsPrice
                                                        ?.toString() ??
                                                    '',
                                              ),
                                              onChanged: (value) =>
                                                  volunteerDetailsProvider
                                                      .setprovideHomeSVisitsPrice(
                                                          int.tryParse(value) ??
                                                              0),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: TextField(
                                              readOnly: volunteerDetailsProvider
                                                  .checkHouseSitting(),
                                              decoration: InputDecoration(
                                                labelText: 'House Sitting',
                                                labelStyle: TextStyle(
                                                  color: LightColors.textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                prefixIcon: Icon(Icons.house),
                                              ),
                                              controller: TextEditingController(
                                                text: volunteerDetailsProvider
                                                        .providesHouseSittingPrice
                                                        ?.toString() ??
                                                    '',
                                              ),
                                              onChanged: (value) =>
                                                  volunteerDetailsProvider
                                                      .setprovideHouseSitting(
                                                          int.tryParse(value) ??
                                                              0),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => volunteerDetailsProvider
                                          .saveProfile(context),
                                      child: Text('Save'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        onUserLogout();
                                        volunteerDetailsProvider
                                            .volunteerLogout(context);
                                      },
                                      child: Text('Logout'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    void navigateToVolunteerAddressPage(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VolunteerAddressPage(), // Replace with your address page widget
        ),
      );
    }

    void handleTap() {
      // Check if the icon is the address icon
      if (icon == Icons.location_on) {
        navigateToVolunteerAddressPage(context);
      }
    }

    return GestureDetector(
      onTap: () {
        handleTap(); // Call the function to handle tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: LightColors.textColor,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: LightColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: LightColors.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  
  Widget buildAddressDetails(VolunteerDetailsGetterProvider volDetailsProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Area/Apartment/Road: ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor,
        ),
      ),
      TextSpan(
        text: '${volDetailsProvider.area_apartment_road ?? ''}',
        style: TextStyle(
          fontSize: 16,
          color: LightColors.textColor,
        ),
      ),
    ],
  ),
),
SizedBox(height: 8),

Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Directions: ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor,
        ),
      ),
      TextSpan(
        text: '${volDetailsProvider.description_directions ?? ''}',
        style: TextStyle(
          fontSize: 16,
          color: LightColors.textColor,
        ),
      ),
    ],
  ),
),
SizedBox(height: 8),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Description: ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor,
        ),
      ),
      TextSpan(
        text: '${volDetailsProvider.main ?? ''}',
        style: TextStyle(
          fontSize: 16,
          color: LightColors.textColor,
        ),
      ),
    ],
  ),
),
SizedBox(height: 8),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Pincode: ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor,
        ),
      ),
      TextSpan(
        text: '${volDetailsProvider.pincode ?? ''}',
        style: TextStyle(
          fontSize: 16,
          color: LightColors.textColor,
        ),
      ),
    ],
  ),
),
SizedBox(height: 8),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'State: ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor,
        ),
      ),
      TextSpan(
        text: '${volDetailsProvider.state ?? ''}',
        style: TextStyle(
          fontSize: 16,
          color: LightColors.textColor,
        ),
      ),
    ],
  ),
),

        ],
      ),
    );
  }

  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
