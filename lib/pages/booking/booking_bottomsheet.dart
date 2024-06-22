import 'package:flutter/material.dart';
import 'package:pet_care/provider/bookind_details_provider.dart';
import 'package:pet_care/provider/get_petData_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/get_volunteer_details_provider.dart'; // Import your VolunteerDetailsGetterProvider
import '../../provider/pets_provider.dart'; // Import your PetsProvider

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var bookingProvider =
          Provider.of<BookingDetailsProvider>(context, listen: false);
      bookingProvider.loadDetails(context);
      bookingProvider.loadPetData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Booking Page");

    var bookingProvider = Provider.of<BookingDetailsProvider>(context);
    // Extract volunteer details from the passed map
    final bool providesHomeVisits = false;
    final bool providesHouseSitting = false;
    final int? providesHomeVisitsPrice = 22;
    final int? providesHouseSittingPrice = 33;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display volunteer details
            Text(
              'Volunteer Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            //Text('Name: ${volunteerProvider.name}'),
            SizedBox(height: 8),
            //  Text('Phone No: ${volunteerProvider.phoneNo}'),
            SizedBox(height: 8),
            // Text('Email: ${volunteerProvider.email}'),
            SizedBox(height: 8),
            //Text('About Me: ${volunteerProvider.aboutMe ?? ''}'),
            SizedBox(height: 16),

            // Display services provided by the volunteer
            Text(
              'Services Provided:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Provides Home Visits: ${providesHomeVisits ? 'Yes' : 'No'}'),
            SizedBox(height: 8),
            if (providesHomeVisits) ...[
              Text('Home Visits Price: ${providesHomeVisitsPrice ?? 'N/A'}'),
              SizedBox(height: 8),
            ],
            Text(
                'Provides House Sitting: ${providesHouseSitting ? 'Yes' : 'No'}'),
            SizedBox(height: 8),
            if (providesHouseSitting) ...[
              Text(
                  'House Sitting Price: ${providesHouseSittingPrice ?? 'N/A'}'),
              SizedBox(height: 8),
            ],
            SizedBox(height: 16),

            // Display pet details owned by the owner
            Text(
              'Pet Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Text(
            //     'Pet Type: ${petsProvider.selectedPetType ?? 'N/A'}'), // Display selected pet type
            // SizedBox(height: 8),
            // Add more details based on your PetsProvider data structure
          ],
        ),
      ),
    );
  }
}
