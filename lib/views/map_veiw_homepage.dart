// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';

class MapHomePage extends StatefulWidget {
  const MapHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapHomePageState();
}

class MapHomePageState extends State<MapHomePage> {
  MapHomePageState();

  GoogleMapController? controller;
  LatLng centerOfZone = const LatLng(24.830617915521096, 46.637221751327004);
  // LatLng centerOfZone = const LatLng(24.481139984189827, 39.55664709067807);
  double radiusOfZone = 30;

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final CircleId circleId = const CircleId("saff_circle");
  Circle? circle;
  void initCircle() {
    Color fillColor = Colors.white.withOpacity(0.8);
    circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Colors.green,
      fillColor: fillColor,
      strokeWidth: 2,
      center: centerOfZone,
      radius: radiusOfZone,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition().then((value) => {print(value)});
    initCircle();
  }

  // calculate distance between two points
  double calculateDistance(LatLng point1, LatLng point2) {
    double distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    return distanceInMeters;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    PreferredSizeWidget appBar = myAppBar(context, false);
    return Scaffold(
        appBar: appBar,
        body: SizedBox(
          width: width,
          height: height - appBar.preferredSize.height,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: centerOfZone,
              zoom: 17,
            ),
            circles: <Circle>{circle!},
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: const Icon(Icons.gps_fixed),
              onPressed: () {
                controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: centerOfZone,
                      zoom: 15,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(
                'Check In',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                Position position = await Geolocator.getCurrentPosition();
                LatLng currentLocation =
                    LatLng(position.latitude, position.longitude);
                double distance =
                    calculateDistance(centerOfZone, currentLocation);
                if (distance <= radiusOfZone) {
                  
                } else {
                  // show dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'You are not in the zone, please check in the zone'),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                }
              },
            ),
          ],
        ));
  }
}
