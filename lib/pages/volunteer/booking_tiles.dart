import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/provider/booking_details_getter.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  final Map<String, String> statusMapping = {
    'Request': 'booked',
    'Accepted': 'Accepted',
    'Rejected': 'Rejected',
    'Completed': 'Completed'
  };

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingDetailsGetterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: bookingProvider.volunteerEmail != null
          ? DefaultTabController(
              length: statusMapping.keys.length,
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(height: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      tabs: statusMapping.keys
                          .map((title) => Tab(text: title))
                          .toList(),
                      labelColor: Colors.deepPurple,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 3.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: statusMapping.values
                          .map((status) => _buildTab(context, status))
                          .toList(),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTab(BuildContext context, String status) {
    final bookingProvider =
        Provider.of<BookingDetailsGetterProvider>(context, listen: false);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: bookingProvider.getBookings(status),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No bookings found for $status'));
        } else {
          List<Map<String, dynamic>> bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> booking = bookings[index];
              List<Map<String, dynamic>> petDetails =
                  booking['petDetails'] ?? [];
              if (bookingProvider.ownerDetails == null) {
                String ownerEmail = booking['ownerEmail'];
                bookingProvider.fetchOwnerDetailsByEmail(ownerEmail);
              }

              String ownerName =
                  bookingProvider.ownerDetails?['name'] ?? 'Loading...';
              String profileImageUrl =
                  bookingProvider.ownerDetails?['profileImageUrl'] ?? '';
              String totalPrice = '${booking['totalPrice']} ₹';
              String locationCity =
                  bookingProvider.ownerDetails?['locationCity'] ?? '';

              return GestureDetector(
                onTap: () {
                  var bId = booking['bookingId'];
                  bookingProvider.fetchBookingDetailsAndNavigate(context, bId);
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFCED8F5).withOpacity(0.8),
                          Color(0xFFD0E6FC),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(profileImageUrl),
                                    radius: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Owner: $ownerName',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Service: ${booking['service']}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Start Date: ${booking['startDate']}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Total Hours: ${booking['totalHours']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'Pets:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: petDetails.map((pet) {
                                            String petType =
                                                pet['selectedPetType'];
                                            String petIconPath =
                                                _getPetIcon(petType);
                                            return Row(
                                              children: [
                                                if (petIconPath.isNotEmpty)
                                                  Image.asset(
                                                    petIconPath,
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '${pet['petName']} - $petType',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        totalPrice,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              'Status: $status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _getPetIcon(String petType) {
    switch (petType.toLowerCase()) {
      case 'dog':
        return 'assets/icons/dog.png';
      case 'cat':
        return 'assets/icons/cat.png';
      case 'bird':
        return 'assets/icons/bird.png';
      default:
        return '';
    }
  }
}
