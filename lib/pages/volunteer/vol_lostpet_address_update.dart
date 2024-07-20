import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_care/services/firestore_service/lost_pet_firestore.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/components/textfield.dart';

class VolLostPetAddressUpdate extends StatefulWidget {
  final String petId;
  const VolLostPetAddressUpdate({Key? key, required this.petId})
      : super(key: key);

  @override
  State<VolLostPetAddressUpdate> createState() =>
      _VolLostPetAddressUpdateState();
}

class _VolLostPetAddressUpdateState extends State<VolLostPetAddressUpdate> {
  late final TextEditingController _directionsController =
      TextEditingController();
  late final TextEditingController _addressMainController =
      TextEditingController();
  late final TextEditingController _apartmentController =
      TextEditingController();
  late final TextEditingController _pincodeController = TextEditingController();

  late final TextEditingController _cityController = TextEditingController();

  late final TextEditingController _descriptionController =
      TextEditingController();

  late final TextEditingController _stateController = TextEditingController();

  late String main;
  late String areaApartmentRoad;
  late String coordinates;
  late String descriptionDirections;
  late String city;
  late String state;
  late String pincode;
  int _characterCount = 0;

  final Completer<GoogleMapController> _controller = Completer();
  late LostPetFirestore _lostPetFirestore;
  @override
  void initState() {
    _lostPetFirestore = LostPetFirestore();
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    Position position = await _determinePosition();
    print("Current location: ${position.latitude}, ${position.longitude}");

    await _updateAddress(LatLng(position.latitude, position.longitude));

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('5'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "My Current POSITION"),
      ));
    });

    CameraPosition cameraPosition = CameraPosition(
      zoom: 11,
      target: LatLng(position.latitude, position.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(28.6139, 77.2088), zoom: 15);

  final List<Marker> _markers = <Marker>[];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _updateAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      coordinates = "${position.latitude},${position.longitude}";

      setState(() {
        _addressMainController.text = address;
      });
      print("Address: $address");
    }
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        controller: _addressMainController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Address will appear here',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: _addressMainController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Address copied to clipboard')));
                            },
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MyTextField(
                        hintText: 'APARTMENT/ROAD/AREA',
                        obsText: false,
                        controller: _apartmentController,
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
                        obsText: false,
                        controller: _pincodeController,
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
                        obsText: false,
                        controller: _cityController,
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
                        obsText: false,
                        controller: _stateController,
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
                                'Enter directions to reach your address (Optional)',
                            obsText: false,
                            controller: _descriptionController,
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
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await saveAddress(widget.petId);
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
        title: Text(' Address Update'),
      ),
      body: Expanded(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (LatLng tappedPoint) async {
                      setState(() {
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: MarkerId('tapped_location'),
                            position: tappedPoint,
                            infoWindow: InfoWindow(title: "Selected Location"),
                          ),
                        );
                      });
                      await _updateAddress(tappedPoint);
                      print(
                          "Tapped location: ${tappedPoint.latitude}, ${tappedPoint.longitude}");
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      Position position = await _determinePosition();
                      print(
                          "Current location: ${position.latitude}, ${position.longitude}");

                      // Update marker position
                      setState(() {
                        _markers.clear();
                        _markers.add(Marker(
                          markerId: MarkerId('current_location'),
                          position:
                              LatLng(position.latitude, position.longitude),
                          infoWindow: InfoWindow(title: "My Current Position"),
                        ));
                      });

                      // Move camera to current location
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 15,
                        ),
                      ));

                      await _updateAddress(
                          LatLng(position.latitude, position.longitude));
                    },
                    child: Icon(Icons.my_location),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space between map and button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Padding around the button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Address:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _addressMainController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Address will appear here',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _addressMainController.text));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Address copied to clipboard')));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between address and button
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Padding around the button
                child: SizedBox(
                  width: double.infinity, // Increase button width
                  child: ElevatedButton(
                    onPressed: () async {
                      Position position = await _determinePosition();
                      print(
                          "Current location: ${position.latitude}, ${position.longitude}");

                      // Update marker position
                      setState(() {
                        _markers.clear();
                        _markers.add(Marker(
                          markerId: MarkerId('current_location'),
                          position:
                              LatLng(position.latitude, position.longitude),
                          infoWindow: InfoWindow(title: "My Current Position"),
                        ));
                      });

                      // Move camera to current location
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 15,
                        ),
                      ));

                      await _updateAddress(
                          LatLng(position.latitude, position.longitude));

                      showCustomBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Button color
                      padding:
                          EdgeInsets.symmetric(vertical: 15), // Button padding
                    ),
                    child: Text('Set Location'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveAddress(String petId) async {
    try {
      await _lostPetFirestore.updateLostPetAddress(
          petId: petId,
          main: _addressMainController.text,
          areaApartmentRoad: _apartmentController.text,
          coordinates: coordinates,
          descriptionDirections: _descriptionController.text,
          city: _cityController.text,
          state: _stateController.text,
          pincode: _pincodeController.text);

      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: Text('Address Updated Successfully!'),
        backgroundColor: Colors.green,
        autoCloseDuration: const Duration(seconds: 5),
      );

      print("Address Save successful!");
    } catch (e) {
      print("Error saving address $e");
      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: Text('Error $e!'),
        backgroundColor: Colors.red,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }
}
