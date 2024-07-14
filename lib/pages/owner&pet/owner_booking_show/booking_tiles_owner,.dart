import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/provider/owner_provider/owner_booking_show_provider.dart';
import 'package:provider/provider.dart';

class StatusOwnerPage extends StatelessWidget {
  final Map<String, String> statusMapping = {
    'Request': 'booked',
    'Accepted': 'accepted',
    'Rejected': 'rejected',
    'Completed': 'Completed'
  };

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingDetailsGetterOwnerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: bookingProvider.ownerEmail != null
          ? DefaultTabController(
              length: statusMapping.keys.length,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    constraints: BoxConstraints(maxHeight: 150.0),
                    child: Material(
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: true,
                        tabs: statusMapping.keys
                            .map((title) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 8.0),
                                  child: Tab(text: title),
                                ))
                            .toList(),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepPurple,
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
          : Center(
              child: Text('No Owner email found.'),
            ),
    );
  }

  Widget _buildTab(BuildContext context, String status) {
    final bookingProvider =
        Provider.of<BookingDetailsGetterOwnerProvider>(context, listen: false);

    return FutureBuilder<List<Map<String, dynamic>>>(

      future: bookingProvider.getBookings(status),

      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } 
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
         else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No bookings found.'));
        }
         else {
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

              // Format the start date
              String formattedStartDate = DateFormat('MMMM dd, yyyy')
                  .format(DateTime.parse(booking['startDate']));

              return GestureDetector(
                onTap: ()  async{
                 await  bookingProvider.fetchBookingDetailsAndNavigate(context,booking['bookingId']);
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFCED8F5).withOpacity(0.8),
                          Color(0xFFD7E2EE),
                          Color(0xFFDCE2F6)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(18),
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
                                          'Location: $locationCity',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Start Date: $formattedStartDate',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Total Hours: ${booking['totalHours']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pets:',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            SizedBox(width: 5),
                                            Row(
                                              children: petDetails.map((pet) {
                                                String petType =
                                                    pet['selectedPetType'];
                                                String petIconPath =
                                                    _getPetIcon(petType);
                                                return petIconPath.isNotEmpty
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 2),
                                                        child: Image.asset(
                                                          petIconPath,
                                                          height: 24,
                                                          width: 24,
                                                        ),
                                                      )
                                                    : SizedBox.shrink();
                                              }).toList(),
                                            ),
                                          ],
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
                                          color: Color(0xFF062483),
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
                              '$status',
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
      case 'rabbit':
        return 'assets/icons/bunny.png';
      default:
        return '';
    }
  }
}
