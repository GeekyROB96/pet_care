import 'package:flutter/material.dart';
import 'package:pet_care/provider/pet_sitter_provider.dart';
import 'package:provider/provider.dart';

import '../volunteer/volunteer_details_page.dart';

class PetSitters extends StatefulWidget {
  const PetSitters({Key? key}) : super(key: key);

  @override
  _PetSittersState createState() => _PetSittersState();
}

class _PetSittersState extends State<PetSitters> {
  late PetSitterProvider _provider;
  String? selectedPetType;
  bool showHouseSitting = false;
  bool showHouseVisit = false;

  @override
  void initState() {
    super.initState();
    _provider = PetSitterProvider()..fetchVolunteers();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pet Sitters'),
        ),
        body: Consumer<PetSitterProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.volunteers.isEmpty) {
              return Center(child: Text('No volunteers found'));
            }
            final filteredVolunteers = provider.volunteers.where((volunteer) {
              // Apply selected pet type filter (if needed)
              if (selectedPetType != null) {
                // Implement pet type filtering logic if required
              }
              // Apply house sitting filter
              if (showHouseSitting &&
                  volunteer['providesHouseSitting'] != true) {
                return false;
              }
              // Apply house visit filter
              if (showHouseVisit && volunteer['providesHomeVisits'] != true) {
                return false;
              }
              return true;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _showSortOptions(context),
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.sort, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(
                                    'Sort By',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showHouseSitting = !showHouseSitting;
                            });
                          },
                          child: Card(
                            color: showHouseSitting
                                ? Colors.blue.withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.home, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(
                                    'House Sitting',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: showHouseSitting
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showHouseVisit = !showHouseVisit;
                            });
                          },
                          child: Card(
                            color: showHouseVisit
                                ? Colors.blue.withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.home, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(
                                    'House Visit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: showHouseVisit
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        _buildPetTypeFilter('dogs'),
                        _buildPetTypeFilter('cats'),
                        _buildPetTypeFilter('rabbits'),
                        _buildPetTypeFilter('birds'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    itemCount: filteredVolunteers.length,
                    itemBuilder: (context, index) {
                      final volunteer = filteredVolunteers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerDetailsPage(
                                volunteer: {
                                  'profileImageUrl':
                                      volunteer['profileImageUrl'],
                                  'name': volunteer['name'],
                                  'email': volunteer['email'],
                                  'uid': volunteer['uid'],
                                  'phoneNo': volunteer['phoneNo'],
                                  'aboutMe': volunteer['aboutMe'],
                                  'locationCity': volunteer['locationCity'],
                                  'prefersDog': volunteer['prefersDog'],
                                  'prefersCat': volunteer['prefersCat'],
                                  'prefersRabbit': volunteer['prefersRabbit'],
                                  'prefersBird': volunteer['prefersBird'],
                                  'age': volunteer['age'],
                                  'occupation': volunteer['occupation'],
                                  'minPrice': volunteer['minPrice'],
                                  'providesDogWalking':
                                      volunteer['providesDogWalking'],
                                  'providesHomeVisits':
                                      volunteer['providesHomeVisits'],
                                  'providesHouseSitting':
                                      volunteer['providesHouseSitting'],
                                  'providesHomeVisitsPrice':
                                      volunteer['providesHomeVisitsPrice'],
                                  'providesHouseSittingPrice':
                                      volunteer['providesHouseSittingPrice'],
                                },
                              ),
                            ),
                          );
                        },
                        child: VolunteerCard(
                            volunteer: volunteer,
                            showHouseSitting: showHouseSitting),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPetTypeFilter(String petType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPetType = petType; // Update selected pet type
        });
      },
      child: Card(
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          child: Row(
            children: [
              Icon(Icons.sort, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                '${petType[0].toUpperCase()}${petType.substring(1)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: UniqueKey(),
              title: Text('Price - Low to High'),
              onTap: () async {
                await _provider.sortByPriceAsc();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price - High to Low'),
              onTap: () async {
                await _provider.sortByPriceDsc();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class VolunteerCard extends StatefulWidget {
  final Map<String, dynamic> volunteer;
  final bool showHouseSitting;

  const VolunteerCard(
      {Key? key, required this.volunteer, required this.showHouseSitting})
      : super(key: key);

  @override
  _VolunteerCardState createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> {
  bool _isLiked = false; // Track whether the volunteer is liked or not

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.volunteer['profileImageUrl'] != null
                    ? NetworkImage(widget.volunteer['profileImageUrl'])
                    : AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.volunteer['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 20),
                        SizedBox(width: 5),
                        Text(
                          widget.volunteer['locationCity'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        if (widget.volunteer['prefersDog'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/dog.png'),
                          ),
                        if (widget.volunteer['prefersCat'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/cat.png'),
                          ),
                        if (widget.volunteer['prefersRabbit'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/rabbit.png'),
                          ),
                        if (widget.volunteer['prefersBird'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/bird.png'),
                          ),
                        if (widget.volunteer['prefersDog'] == true ||
                            widget.volunteer['prefersCat'] == true ||
                            widget.volunteer['prefersRabbit'] == true ||
                            widget.volunteer['prefersBird'] == true)
                          Text(
                            '|',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        if (widget.volunteer['providesDogWalking'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/pet_walk.png'),
                          ),
                        if (widget.volunteer['providesHomeVisits'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/pet_home.png'),
                          ),
                        if (widget.volunteer['providesHouseSitting'] == true)
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icons/pet_sitter.png'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'From',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        (widget.showHouseSitting == true)
                            ? '${widget.volunteer['providesHouseSittingPrice'] ?? 0} INR'
                            : '${widget.volunteer['providesHomeVisitsPrice'] ?? 0} INR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: _isLiked
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked; // Toggle liked state
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
