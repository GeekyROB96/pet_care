import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pet_care/provider/payment_page_provider.dart';

class PaymentPageVolunteer extends StatelessWidget {
  final String bookingId;

  PaymentPageVolunteer({required this.bookingId});

  Future<void> _showConfirmationDialog(BuildContext context) async {
  var provider = Provider.of<PaymentPageProvider>(context, listen: false);
  await provider.loadData(bookingId, context);
  // provider.confirmPayment(); // Remove this line, it's already called in onPressed

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Payment'),
        content: Text(
          'I confirm that I have recieved the payment for this booking'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Set all necessary variables before confirming payment
              provider.setBookingId(this.bookingId);
              provider.setOrderStatus('Payment Completed!');

              await provider.updatePayment();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentPageProvider()..loadData(bookingId, context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Booking Payment'),
          centerTitle: true,
        ),
        body: Consumer<PaymentPageProvider>(
          builder: (context, provider, child) {
            if (provider.bookingId == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              String vpa = provider.vpa ?? 'VPA'; // Assuming provider.vpa is a String

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: provider.vImageUrl != null
                                  ? NetworkImage(provider.vImageUrl!)
                                  : AssetImage(
                                      'assets/images/default_profile.png')
                                      as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      color: Color.fromARGB(142, 255, 255, 252),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Payee Name: ${provider.vName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Booking ID: ${provider.bookingId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'VPA:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.clip,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: vpa));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('VPA copied to clipboard'),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          vpa,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.copy, size: 24),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Consumer<PaymentPageProvider>(
                                  builder: (context, provider, child) {
                                    return Text(
                                      '₹ ${provider.amount?.toString() ?? '0.00'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Status:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Consumer<PaymentPageProvider>(
                                  builder: (context, provider, child) {
                                    return Text(
                                      '${provider.orderStatus?.toString() ?? 'Payment Pending'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                              context); // Call the function here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Verify Payment',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
