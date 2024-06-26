import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/bookind_details_provider.dart';
import '../../widgets/components/textfield.dart';

class BookingDetailsPage extends StatefulWidget {
  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final TextEditingController serviceTextController = TextEditingController();
  final TextEditingController petTextController = TextEditingController();
  final TextEditingController dateTimeRangeController = TextEditingController();
  String selectedService = '';
  List<String> selectedPets = []; // Changed to List<String>
  String selectedServicePrice = ''; // Added for displaying service price
  DateTime? startDate;
  DateTime? endDate;
  double totalHours = 0.0;
  double totalPrice = 0.0;
  late final bookingDetailsProvider;

  @override
  void initState() {
    super.initState();
    _loadDetailsAndPetData();
  }

  void _loadDetailsAndPetData() async {
    bookingDetailsProvider =
        Provider.of<BookingDetailsProvider>(context, listen: false);
    await bookingDetailsProvider.loadDetails(context);
    await bookingDetailsProvider.loadPetData(context);
  }

  @override
  void dispose() {
    serviceTextController.dispose();
    petTextController.dispose();
    dateTimeRangeController.dispose();
    super.dispose();
  }

  void _showServicesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildServiceItem(
                icon: Icons.home,
                title: 'Home Visit',
                description:
                    'The sitter visits your home to check on the pet,\nfeed your pet, and play with it.',
              ),
              Divider(),
              _buildServiceItem(
                icon: Icons.business,
                title: 'House Sitting',
                description:
                    'The pet sitter takes care of your pet in their house.',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPetListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: ListView.separated(
              itemCount: bookingDetailsProvider.petList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final pet = bookingDetailsProvider.petList[index];
                bool isSelected = selectedPets.contains(pet['petName']);
                return _buildPetItem(
                  icon: Icons.pets,
                  pet: pet['petName'] ?? 'N/A',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedPets.remove(pet['petName']);
                      } else {
                        selectedPets.add(pet['petName']);
                      }
                      petTextController.text = selectedPets.join(', ');
                      bookingDetailsProvider
                          .setPet(selectedPets); // Update here
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    List<DateTime>? picked = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: startDate ?? DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(const Duration(days: 3652)),
      endInitialDate: endDate ?? DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: true,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(begin: 0, end: 1),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    if (picked != null && picked.length == 2) {
      if (picked[1].isBefore(picked[0])) {
        // Show an error message if the end date is before the start date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End date cannot be earlier than start date')),
        );
      } else {
        setState(() {
          startDate = picked[0];
          endDate = picked[1];
          dateTimeRangeController.text =
              '${DateFormat.yMMMd().add_jm().format(startDate!)} - ${DateFormat.yMMMd().add_jm().format(endDate!)}';
          totalHours = endDate!.difference(startDate!).inHours.toDouble();
          bookingDetailsProvider.setTotalHours(totalHours!);
          totalPrice = _calculateTotalPrice(selectedService, totalHours!);
        });
      }
    }
  }

  double _calculateTotalPrice(String service, double hours) {
    final bookingDetailsProvider =
        Provider.of<BookingDetailsProvider>(context, listen: false);
    double price = 0.0;

    if (service == 'Home Visit') {
      price = (bookingDetailsProvider.homeVisitPrice ?? 0) * hours;
    } else if (service == 'House Sitting') {
      price = (bookingDetailsProvider.houseSittingPrice ?? 0) * hours;
    }
    return price;
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    bool isSelected = selectedService == title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Icon(icon),
          title: Text(title),
          subtitle: description.isNotEmpty ? Text(description) : null,
          onTap: () {
            setState(() {
              selectedService = title;
              serviceTextController.text = selectedService;
              selectedServicePrice = _getServicePrice(selectedService);

              totalPrice = _calculateTotalPrice(selectedService, totalHours);
            });
            Navigator.pop(context);
          },
          trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
        ),
        Divider(),
      ],
    );
  }

  String _getServicePrice(String service) {
    final bookingDetailsProvider =
        Provider.of<BookingDetailsProvider>(context, listen: false);

    if (service == 'Home Visit') {
      return '${bookingDetailsProvider.homeVisitPrice ?? 'N/A'} INR';
    } else if (service == 'House Sitting') {
      return '${bookingDetailsProvider.houseSittingPrice ?? 'N/A'} INR';
    } else {
      return 'N/A';
    }
  }

  Widget _buildPetItem({
    required IconData icon,
    required String pet,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(icon),
      title: Text(pet),
      onTap: onTap,
      trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    if (title.startsWith('Selected Date')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Booking Details'),
      ),
      body: Consumer<BookingDetailsProvider>(
        builder: (context, bookingDetails, child) {
          if (bookingDetails.homeVisit == null &&
              bookingDetails.houseSitting == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFCEE3F8).withOpacity(0.9),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/service.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'House Sitting',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${bookingDetails.houseSittingPrice ?? 'N/A'} INR',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'per hour',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/ser.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Home Visit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${bookingDetails.homeVisitPrice ?? 'N/A'} INR',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'per visit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    hintText: 'Select Service',
                    obsText: false,
                    controller: serviceTextController,
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                    textStyle: TextStyle(fontSize: 16.0),
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/icons/ser.png'),
                      ),
                      onPressed: () {
                        _showServicesBottomSheet(context);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    hintText: 'Select Your Pet',
                    obsText: false,
                    controller: petTextController,
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                    textStyle: TextStyle(fontSize: 16.0),
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/images/pet-icon.png'),
                      ),
                      onPressed: () {
                        _showPetListBottomSheet(context);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _showDateTimePicker(context);
                    },
                    child: MyTextField(
                      hintText: 'Select Date and Time Range',
                      obsText: false,
                      controller: dateTimeRangeController,
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                      textStyle: TextStyle(fontSize: 16.0),
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: ImageIcon(
                          AssetImage('assets/icons/calendar.png'),
                        ),
                        onPressed: () {
                          _showDateTimePicker(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFC5DDF5).withOpacity(0.9),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _buildSummaryItem('Selected Service:', selectedService),
                        SizedBox(height: 12),
                        _buildSummaryItem(
                            'Selected Pet(s)', selectedPets.join(', ')),
                        SizedBox(height: 12),
                        _buildSummaryItem('Selected Date and Time Range:',
                            dateTimeRangeController.text),
                        SizedBox(height: 12),
                        _buildSummaryItem('Service Price:',
                            _getServicePrice(selectedService)),
                        SizedBox(height: 12),
                        _buildSummaryItem(
                            'Total Hours:', _calculateTotalHours().toString()),
                        SizedBox(height: 12),
                        _buildSummaryItem(
                            'Total Price:',
                            _calculateTotalPrice(selectedService, totalHours)
                                .toString()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      bookingDetailsProvider
                          .setStartDate(startDate?.toIso8601String());
                      bookingDetailsProvider
                          .setEndDate(endDate?.toIso8601String());
                      bookingDetailsProvider.setService(selectedService);
                      bookingDetailsProvider
                          .setServicePrice(selectedServicePrice);
                      bookingDetailsProvider.setTotalHours(totalHours);
                      bookingDetailsProvider.setTotalPrice(totalPrice);
                      bookingDetailsProvider
                          .setPet(selectedPets); // Update here

                      bookingDetailsProvider.saveBooking(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF94A5E8), // Background color of the button
                      minimumSize: Size(double.infinity,
                          50), // Width and height of the button
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateTotalHours() {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inHours.toDouble();
    }
    return 0;
  }
}
