import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/provider/payment_page_provider.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;

  PaymentPage({required this.bookingId});

  Future<void> _showConfirmationDialog(BuildContext context) async {
    var provider = Provider.of<PaymentPageProvider>(context, listen: false);
    await provider.loadData(bookingId, context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Payment'),
          content: Text(
            'I confirm that I have paid the booking amount to the mentioned receiver VPA',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                provider.setBookingId(this.bookingId);
                provider.setOrderStatus('Payment Completed');

                await provider.confirmPayment();
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
          title: Text('Payment Details'),
          centerTitle: true,
        ),
        body: Consumer<PaymentPageProvider>(
          builder: (context, provider, child) {
            if (provider.bookingId == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              String vpa =
                  provider.vpa ?? 'VPA'; // Assuming provider.vpa is a String

              // Determine the icon and color based on payment status
              Icon paymentIcon;
              Color paymentColor;
              String paymentStatusText;

              if (provider.orderStatus == 'Payment Completed') {
                paymentIcon =
                    Icon(Icons.check_circle, color: Colors.green, size: 36);
                paymentColor = Colors.green;
                paymentStatusText = 'Payment Completed';
              } else {
                paymentIcon = Icon(Icons.warning, color: Colors.red, size: 36);
                paymentColor = Colors.red;
                paymentStatusText = 'Payment Pending';
              }

              return SingleChildScrollView(
                child: Padding(
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
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹ ${provider.amount?.toString() ?? '0.00'}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                paymentIcon,
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              paymentStatusText,
                              style:
                                  TextStyle(fontSize: 18, color: paymentColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 280, // Increase card height
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFAECAFA), Color(0xFFBFC9EF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          //color: Colors.transparent, // Transparent for gradient
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payee Name: ${provider.vName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Booking ID: ${provider.bookingId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'VPA:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                              ClipboardData(text: vpa));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'VPA copied to clipboard'),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                vpa,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.copy, size: 24),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Status:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${provider.orderStatus?.toString() ?? 'Payment Pending'}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7492F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Confirm Payment',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
