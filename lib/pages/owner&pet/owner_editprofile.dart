import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:pet_care/provider/owner_editprofile_provider.dart';
import 'package:provider/provider.dart';

class OwnerEditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: LightColors.textColor,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<OwnerDetailsGetterProvider>(
          builder: (context, ownerDetailsProvider, child) {
            return ownerDetailsProvider.isDataLoaded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  getImageProvider(ownerDetailsProvider),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => ownerDetailsProvider
                                    .pickProfileImage(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTextField(
                        label: 'Name',
                        initialValue: ownerDetailsProvider.name,
                        onChanged: (value) =>
                            Provider.of<OwnerEditProfileProvider>(context,
                                    listen: false)
                                .setName(value),
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        label: 'Email',
                        initialValue: ownerDetailsProvider.email,
                        enabled: false, // Make the email field non-editable
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        label: 'Phone Number',
                        initialValue: ownerDetailsProvider.phoneNo,
                        onChanged: (value) =>
                            Provider.of<OwnerEditProfileProvider>(context,
                                    listen: false)
                                .setPhoneNo(value),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                ownerDetailsProvider.saveProfile(context),
                            child: Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LightColors.primaryColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                ownerDetailsProvider.ownerLogout(context),
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

  Widget buildTextField({
    required String label,
    required String initialValue,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: LightColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextStyle(
        fontSize: 16,
        color: LightColors.textColor,
      ),
      onChanged: onChanged,
      enabled: enabled,
      controller: TextEditingController(
          text: initialValue), // Initialize controller with initialValue
    );
  }

  ImageProvider getImageProvider(
      OwnerDetailsGetterProvider ownerDetailsProvider) {
    if (ownerDetailsProvider.profileImageUrl != null) {
      return NetworkImage(ownerDetailsProvider.profileImageUrl!);
    } else {
      if (ownerDetailsProvider.profileImageFile != null) {
        return FileImage(ownerDetailsProvider.profileImageFile!);
      } else {
        return AssetImage('assets/images/default.png');
      }
    }
  }
}
