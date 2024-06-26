import 'package:flutter/material.dart';

import '../../widgets/components/textfield.dart';

class OwnerAddressPage extends StatefulWidget {
  const OwnerAddressPage({Key? key}) : super(key: key);

  @override
  State<OwnerAddressPage> createState() => _OwnerAddressPageState();
}

class _OwnerAddressPageState extends State<OwnerAddressPage> {
  final TextEditingController _directionsController = TextEditingController();
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showCustomBottomSheet(context);
    });
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context); // Dismiss bottom sheet
          },
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'A detailed address will help us to reach you exactly!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepOrange.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    // TextFields with outline borders
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'HOUSE/FLAT/BLOCK NO',
                        obsText: false,
                        controller: TextEditingController(),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),
                    Divider(), // Divider below the first text field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'APARTMENT/ROAD/AREA',
                        obsText: true,
                        controller: TextEditingController(),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'PIN CODE',
                        obsText: true,
                        controller: TextEditingController(),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'CITY',
                        obsText: true,
                        controller: TextEditingController(),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.house_outlined),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'STATE',
                        obsText: true,
                        controller: TextEditingController(),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            hintText:
                                'Enter directions to reach your address(Optional)',
                            obsText: false,
                            controller: _directionsController,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$_characterCount/200',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    // Save as Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Save as',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.home),
                                        SizedBox(width: 8),
                                        Text(
                                          'Home',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people_alt_outlined),
                                        SizedBox(width: 8),
                                        Text(
                                          'Friends & Family',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Save Address Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement the save action here
                          },
                          child: Text('Save Address'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Address Page'),
      ),
      body: Center(),
    );
  }
}
