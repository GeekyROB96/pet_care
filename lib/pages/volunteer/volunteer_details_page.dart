import 'package:flutter/material.dart';
import 'package:pet_care/provider/get_volunteer_details_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/light_colors.dart';

class VolunteerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> volunteer;

  const VolunteerDetailsPage({Key? key, required this.volunteer})
      : super(key: key);

  @override
  _VolunteerDetailsPageState createState() => _VolunteerDetailsPageState();
}

class _VolunteerDetailsPageState extends State<VolunteerDetailsPage> {
  bool showAboutMeFull = false;

  late final Map<String, dynamic> vData;

  void navgateToBookingPage() {
    Navigator.pushNamed(context, '/bookingPage');
  }

  @override
  Widget build(BuildContext context) {
    String currentuidd = widget.volunteer['uid'];
    String set = Provider.of<VolunteerDetailsGetterProvider>(context)
        .currentuid = currentuidd;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            child: Stack(
              children: [
                widget.volunteer['profileImageUrl'] != null
                    ? Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.35,
                          backgroundImage: NetworkImage(
                            widget.volunteer['profileImageUrl'],
                          ),
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.35,
                          backgroundImage:
                              AssetImage('assets/images/default_profile.png'),
                        ),
                      ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD9E9FA).withOpacity(0.8),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${widget.volunteer['name']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: LightColors.textColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.black),
                              SizedBox(width: 5),
                              Text(
                                widget.volunteer['locationCity'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Age',
                                  widget.volunteer['age'] ?? 'N/A',
                                  Color(0xD1F8ABCB),
                                ),
                              ),
                              Expanded(
                                child: _buildInfoCard(
                                  'Occupation',
                                  widget.volunteer['occupation'] ?? 'N/A',
                                  Color(0xFFC6E7F1),
                                ),
                              ),
                              Expanded(
                                child: _buildInfoCard(
                                  'Location',
                                  widget.volunteer['locationCity'] ?? 'N/A',
                                  Color(0xC1D3C9F6),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          _buildPriceCard(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildAboutMeSection(),
                    SizedBox(height: 20),
                    _buildPreferredPets(),
                    SizedBox(height: 20),
                    _buildServicesProvided(),
                    SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection() {
    String aboutMe = widget.volunteer['aboutMe'] ?? 'Not provided';
    bool showSeeMore = aboutMe.length > 90;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'About Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightColors.textColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          showSeeMore
              ? (showAboutMeFull ? aboutMe : '${aboutMe.substring(0, 90)}...')
              : aboutMe,
          style: TextStyle(
            fontSize: 16,
            color: LightColors.textColor,
          ),
        ),
        if (showSeeMore) SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              showAboutMeFull = !showAboutMeFull;
            });
          },
          child: Text(
            showAboutMeFull ? 'See less' : 'See more',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      width: 93,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LightColors.textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: LightColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    String homeVisitPrice = widget.volunteer['providesHomeVisitsPrice'] != null
        ? '${widget.volunteer['providesHomeVisitsPrice']} \ INR'
        : 'N/A';

    String houseSittingPrice =
        widget.volunteer['providesHouseSittingPrice'] != null
            ? '${widget.volunteer['providesHouseSittingPrice']} \ INR'
            : 'N/A';

    return Container(
      width: double.infinity,
      //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color(0xFFBAC7F3), // Background color
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prices',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: LightColors.textColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Home Visit:',
                        style: TextStyle(
                            fontSize: 16, color: LightColors.textColor),
                      ),
                    ],
                  ),
                  Text(
                    homeVisitPrice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LightColors.textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.house,
                        color: LightColors.textColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'House Sitting:',
                        style: TextStyle(
                            fontSize: 16, color: LightColors.textColor),
                      ),
                    ],
                  ),
                  Text(
                    houseSittingPrice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LightColors.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferredPets() {
    List<String> preferredPets = [];

    if (widget.volunteer['prefersDog'] == true) {
      preferredPets.add('Dog');
    }
    if (widget.volunteer['prefersCat'] == true) {
      preferredPets.add('Cat');
    }
    if (widget.volunteer['prefersRabbit'] == true) {
      preferredPets.add('Rabbit');
    }
    if (widget.volunteer['prefersBird'] == true) {
      preferredPets.add('Bird');
    }

    if (preferredPets.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Pets:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Wrap(
          spacing: 8.0,
          children: preferredPets
              .map((pet) => Chip(
                    label: Text(
                      pet,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildServicesProvided() {
    List<String> servicesProvided = [];

    if (widget.volunteer['providesDogWalking'] == true) {
      servicesProvided.add('Dog Walking');
    }
    if (widget.volunteer['providesHomeVisits'] == true) {
      servicesProvided.add('Home Visits');
    }
    if (widget.volunteer['providesHouseSitting'] == true) {
      servicesProvided.add('House Sitting');
    }

    if (servicesProvided.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services Provided:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Wrap(
          spacing: 8.0,
          children: servicesProvided
              .map((service) => Chip(
                    label: Text(
                      service,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Tooltip(
              message: 'Know the time and availability',
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.chat),
                label: Text('Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF72B1F1),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                //getvolunteerDataAndnavigate();
                navgateToBookingPage();
              },
              icon: Icon(Icons.favorite_border),
              label: Text('Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF72B1F1),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
