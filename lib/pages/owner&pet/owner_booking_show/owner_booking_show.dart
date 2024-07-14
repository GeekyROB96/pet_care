import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/pages/owner&pet/payments_page.dart';
import 'package:pet_care/provider/owner_provider/owner_booking_show_provider.dart';
import 'package:provider/provider.dart';

class BookingDetailsOwnerShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookingProvider =
        Provider.of<BookingDetailsGetterOwnerProvider>(context);
    final booking = bookingProvider.selectedBooking;
    final ownerDetails = bookingProvider.ownerDetails;

    if (booking == null || ownerDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Booking Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String ownerName = ownerDetails['name'] ?? 'Loading...';
    String profileImageUrl = ownerDetails['profileImageUrl'] ?? '';
    List<dynamic> pets = booking['pet'] ?? [];
    String oEmail = booking['ownerEmail'];
    String addressText = 'NA';

    if (booking['oaddressDetails'] != null) {
      bookingProvider.setOwnerAddress(booking['oaddressDetails']);
    }
    if (booking['vDataAddress'] != null) {
      bookingProvider.setVolunteerAddress(booking['vDataAddress']);
    }

    // Determine which address to display
    if (bookingProvider.oaddressDetails != null) {
      addressText = getAddress(bookingProvider.oaddressDetails!);
    } else if (bookingProvider.vDataAddress != null) {
      addressText = getAddress(bookingProvider.vDataAddress!);
    }

    // Date format for displaying dates
    DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black,
                  ),
                  Text(
                    '${booking['bookingId']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 50,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Owner: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ownerName,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pets: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: pets
                                  .map((pet) => GestureDetector(
                                        onTap: () async {
                                          print(
                                            "Pets: ${pet}",
                                          );
                                          print("OwnerEmail: $oEmail");
                                          await bookingProvider
                                              .navigateAndgetPetByName(
                                                  pet, oEmail, context);
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              pet.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 243, 184, 33),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Booking Details: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            color: Color.fromARGB(255, 161, 161, 161),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Start Date Time: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: dateFormat.format(
                                      DateTime.parse(booking['startDate'])),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'End Date Time: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: dateFormat.format(
                                      DateTime.parse(booking['endDate'])),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Total Hours ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${booking['totalHours']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Service Opted : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${booking['service']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Address : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: addressText,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Total Price : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${booking['totalPrice']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Handle accept action
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PaymentPage(bookingId: booking['bookingId']);
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              //overlayColor: Colors.black,
                            ),
                            child: Text('Pay Now'),
                          ),
                        ),
                        SizedBox(
                            width: 16), 
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                               await bookingProvider.deleteBooking(
                                  booking['bookingId'], context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              //overlayColor: Colors.black,
                            ),
                            child: Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAddress(Map<String, dynamic> addressDetails) {
    if (addressDetails == null) {
      return 'Address not available';
    }

    String areaApartmentRoad = addressDetails['area_apartment_road'] ?? '';
    String city = addressDetails['city'] ?? '';
    String state = addressDetails['state'] ?? '';
    String pincode = addressDetails['pincode'] ?? '';
    String houseFlatData = addressDetails['house_flat_data'] ?? '';
    String descriptionDirections =
        addressDetails['description_directions'] ?? '';

    return '$areaApartmentRoad,\n $houseFlatData, \n $city, $state, $pincode. \n $descriptionDirections';
  }
}
