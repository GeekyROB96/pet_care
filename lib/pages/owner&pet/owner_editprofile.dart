import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:pet_care/provider/get_ownerData_provider.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'add__owner_address.dart';

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
        child: SingleChildScrollView(
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
                          enabled: false,
                          prefixIcon: Icons.person_outline,
                        ),
                        buildTextField(
                          label: 'Email',
                          initialValue: ownerDetailsProvider.email,
                          enabled: false,
                          prefixIcon: Icons.email_outlined,
                        ),
                        buildTextField(
                          label: 'Phone Number',
                          initialValue: ownerDetailsProvider.phoneNo,
                          enabled: false,
                          prefixIcon: Icons.phone_outlined,
                        ),
                        buildAddressField(context, ownerDetailsProvider),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await ownerDetailsProvider.saveProfile(context);
                                Navigator.pop(
                                    context); // Pop the edit profile page
                              },
                              child: Text('Save'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LightColors.primaryColor,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                onUserLogout();
                                ownerDetailsProvider.ownerLogout(context);
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
    );
  }

  Widget buildTextField({
    required String label,
    required String initialValue,
    bool enabled = true,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            labelText: label,
            labelStyle: TextStyle(
              color: LightColors.textColor,
              fontSize: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: LightColors.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: LightColors.textColor,
          ),
          enabled: enabled,
          controller: TextEditingController(
            text: initialValue,
          ),
        ),
        if (label != 'Phone Number') SizedBox(height: 12),
      ],
    );
  }

  Widget buildAddressField(
      BuildContext context, OwnerDetailsGetterProvider ownerDetailsProvider) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerAddressPage(),
          ),
        );
        if (result != null) {}
      },
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.home),
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: LightColors.textColor,
                  fontSize: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: LightColors.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black,
                )),
            style: TextStyle(
              fontSize: 16,
              color: LightColors.textColor,
            ),
            enabled: false, // Make the TextField uneditable
          ),
          buildAddressDetails(ownerDetailsProvider)
        ],
      ),
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

  Widget buildAddressDetails(OwnerDetailsGetterProvider ownerDetailsProvider) {
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
                  text: '${ownerDetailsProvider.area_apartment_road ?? ''}',
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
                  text: 'City: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: LightColors.textColor,
                  ),
                ),
                TextSpan(
                  text: '${ownerDetailsProvider.city ?? ''}',
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
                  text: '${ownerDetailsProvider.description_directions ?? ''}',
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
                  text: '${ownerDetailsProvider.main ?? ''}',
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
                  text: '${ownerDetailsProvider.pincode ?? ''}',
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
                  text: '${ownerDetailsProvider.state ?? ''}',
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
