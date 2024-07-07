import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final List<String> tabTitles = [
    'Request',
    'Accepted',
    'Rejected',
    'Completed'
  ];
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _volunteerEmail;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
  }

  Future<void> _fetchCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _volunteerEmail = user.email;
      });
    }
  }

  Future<List<Map<String, dynamic>>> getBookings(
      String volEmail, String status) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('volEmail', isEqualTo: volEmail)
        .where('status', isEqualTo: status)
        .get();

    return querySnapshot.docs
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: _volunteerEmail != null
          ? DefaultTabController(
              length: tabTitles.length,
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
                      tabs: tabTitles.map((title) => Tab(text: title)).toList(),
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
                      children: [
                        _buildTab('booked'),
                        _buildTab('accepted'),
                        _buildTab('rejected'),
                        _buildTab('completed'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTab(String status) {
    return FutureBuilder(
      future: getBookings(_volunteerEmail!, status),
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
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Booking ID: ${booking['bookingId']}'),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Service: ${booking['service']}'),
                      Text('Owner Email: ${booking['ownerEmail']}'),
                      Text('Start Date: ${booking['startDate']}'),
                      Text('End Date: ${booking['endDate']}'),
                      Text('Total Hours: ${booking['totalHours']}'),
                      Text('Total Price: ${booking['totalPrice']}'),
                    ],
                  ),
                  //trailing: Text('Status: ${booking['status']}'),
                  onTap: () {
                    // Handle tapping on a booking item
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
