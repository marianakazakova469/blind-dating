// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uncommon_grounds/pages/input_longevity_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';

class InputDistancePreferenceScreen extends StatefulWidget {
  const InputDistancePreferenceScreen({super.key});

  @override
  State<InputDistancePreferenceScreen> createState() =>
      _InputDistancePreferenceScreenState();
}

class _InputDistancePreferenceScreenState
    extends State<InputDistancePreferenceScreen> {
  double _currentSliderValueDouble = 20;
  int _currentSliderValueInt = 20;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  GoogleMapController? _mapController;
  LatLng _initialCameraPosition =
      const LatLng(37.7749, -122.4194); // default cordinates

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  // In order to request location, you should always check Location Service status and Permission status manually.
  // (this is according to the plugin)
  Future<void> _getUserLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          log("Location service disabled.");
          return;
        }
      }
      // request location permission
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          log("Location permission denied.");
          return;
        }
      }

      _locationData = await location.getLocation();
      if (_locationData != null) {
        // for debugging 
        log("user location: ${_locationData!.latitude}, ${_locationData!.longitude}");
        setState(() {
          _initialCameraPosition = LatLng(
            _locationData!.latitude!,
            _locationData!.longitude!,
          );
        });
        // if the map is already created, update the camera position
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(_initialCameraPosition),
          );
        }
      } else {
        log("_locationData is null"); // for debugging
      }
    } catch (error) {
      log("Error fetching location: $error");
    }
  }

  void _saveUserData() async {
    try {
      // add the distance preference which the user 
      // has set by using the slider to the database
      await _firestore.collection('users').doc('user_unique_id').set({
        'distancePreference': _currentSliderValueInt,
      }, SetOptions(merge: true));

      //  navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LongevitySelector()),
      );
    } catch (error) {
      // for any errors just in case
      log("Error saving data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          iconTheme: const IconThemeData(color: purple),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset('assets/images/logo.png'),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the distance preference',
                      style: TextStyle(
                          color: white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.50),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Use the slider to set the maximum distance you want your potential matches to be located',
                      style: TextStyle(
                        color: purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                        letterSpacing: 0.32,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distance preference',
                          style: TextStyle(
                              color: green,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '$_currentSliderValueInt km',
                          style: TextStyle(
                              color: green,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Slider.adaptive(
                      thumbColor: white,
                      value: _currentSliderValueDouble,
                      max: 100,
                      inactiveColor: const Color.fromARGB(80, 197, 242, 118),
                      activeColor: green,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValueDouble = value;
                          _currentSliderValueInt = value.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // the map should always be inside a container
                    Container(
                      height: 300,
                      // takes up all the width in the parent container
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            initialCameraPosition: CameraPosition(
                              //set the initial camera position until the map is fully initialized
                              target: _initialCameraPosition,
                              zoom: 14,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              if (_locationData != null) {
                                _mapController!.animateCamera(
                                  // update the location on the map to match the ocation of the device
                                  CameraUpdate.newLatLng(
                                    LatLng(
                                      _locationData!.latitude!,
                                      _locationData!.longitude!,
                                    ),
                                  ),
                                );
                              }
                            },
                            markers: {
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                position: LatLng(
                                  _locationData!.latitude!,
                                  _locationData!.longitude!,
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                              ),
                            },
                          )),
                    ),
                  ],
                ),
                ButtonPrimary(
                  label: 'NEXT',
                  onPressed: _saveUserData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}