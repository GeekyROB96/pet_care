import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:pet_care/provider/get_volunteer_details.dart';
import 'package:provider/provider.dart';

class VolunteerEditProfilePage extends StatelessWidget {
  const VolunteerEditProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: LightColors.textColor,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<VolunteerDetailsGetterProvider>(
          builder: (context, volunteerDetailsProvider, child) {
            return volunteerDetailsProvider.isDataLoaded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: volunteerDetailsProvider.profileImageUrl != null
                                  ? NetworkImage(volunteerDetailsProvider.profileImageUrl!)
                                  : AssetImage('assets/images/default.png') as ImageProvider, // Use AssetImage for local default image
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => volunteerDetailsProvider.pickProfileImage(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Name:',
                        style: TextStyle(
                          color: LightColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        volunteerDetailsProvider.name,
                        style: TextStyle(
                          color: LightColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email:',
                        style: TextStyle(
                          color: LightColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        volunteerDetailsProvider.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: LightColors.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            color: LightColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) => volunteerDetailsProvider.setPhoneNo(value),
                        controller: TextEditingController(
                          text: volunteerDetailsProvider.phoneNo,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'About Me',
                          labelStyle: TextStyle(
                            color: LightColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) => volunteerDetailsProvider.setaboutMe(value),
                        controller: TextEditingController(
                          text: volunteerDetailsProvider.aboutMe,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => volunteerDetailsProvider.saveProfile(context),
                            child: Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LightColors.primaryColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => volunteerDetailsProvider.volunteerLogout(context),
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
    );
  }
}
