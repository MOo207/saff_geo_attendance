// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saff_geo_attendence/helper/constants.dart';
import 'package:saff_geo_attendence/models/attendence.dart';
import 'package:saff_geo_attendence/models/user.dart';
import 'package:saff_geo_attendence/services/attendence_service.dart';
import 'package:saff_geo_attendence/services/auth_service.dart';
import 'package:saff_geo_attendence/views/login_view.dart';
import 'package:saff_geo_attendence/views/settings_view.dart';
import 'package:saff_geo_attendence/views/user_attendence_view.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapHomePage extends StatefulWidget {
  User? loggedInUser;
  MapHomePage({Key? key, this.loggedInUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapHomePageState();
}

class MapHomePageState extends State<MapHomePage> {
  MapHomePageState();
  bool? serviceEnabled;
  LocationPermission? permission;
  double zoom = 17;

  GoogleMapController? controller;
  LatLng centerOfZone = const LatLng(24.830617915521096, 46.637221751327004);
  // LatLng centerOfZone = const LatLng(24.485550289681754, 39.55926658692821);
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
      strokeColor: Constants.primaryColor,
      fillColor: fillColor,
      strokeWidth: 2,
      center: centerOfZone,
      radius: radiusOfZone,
    );
  }

  Future<Map<bool, String>> _checkPermission() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      // enable location service

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {false: 'Location services are disabled.'};
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
        return {false: 'Location permissions are denied, try again'};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        false:
            'Location permissions are permanently denied, we cannot request permissions.'
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return {true: "done"};
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("SAFF User"),
                accountEmail: Text(widget.loggedInUser!.email.toString()),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // UserAttendenceView
              ListTile(
                leading: Icon(Icons.holiday_village),
                title: Text("User Attendence"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserAttendenceView(
                                loggedInUser: widget.loggedInUser,
                              )));
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsView()));
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sign_out),
                leading: Icon(Icons.logout),
                onTap: () async {
                  Navigator.pop(context);
                  AuthService auth = AuthService();
                  await auth.logout(widget.loggedInUser!.id!);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginView()));
                },
              ),
              // delete account
              ListTile(
                title: Text("Delete Account"),
                leading: Icon(Icons.delete),
                onTap: () async {
                  Navigator.pop(context);
                  AuthService auth = AuthService();
                  await auth.deleteAccount(widget.loggedInUser!.id!);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginView()));
                },
              ),
            ],
          ),
        ),
        appBar: appBar,
        body: SizedBox(
          width: width,
          height: height - appBar.preferredSize.height,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: centerOfZone,
              zoom: zoom,
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
              onPressed: () async {
                Map<bool, String> checkPermission = await _checkPermission();
                if (checkPermission.containsKey(true)) {
                  Position position = await Geolocator.getCurrentPosition();
                  LatLng currentLocation =
                      LatLng(position.latitude, position.longitude);
                  controller?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: currentLocation,
                        zoom: zoom,
                      ),
                    ),
                  );
                } else {
                  String error = checkPermission[false].toString();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error), duration: Duration(seconds: 2)));
                }
              },
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(
                'Check In',
              ),
              icon: const Icon(
                Icons.check,
              ),
              onPressed: () async {
                Position position = await Geolocator.getCurrentPosition();
                LatLng currentLocation =
                    LatLng(position.latitude, position.longitude);
                double distance =
                    calculateDistance(centerOfZone, currentLocation);
                if (distance <= radiusOfZone) {
                  // check in
                  // check if user is already checked in
                  AttendenceService attendenceService =
                      AttendenceService.instance;
                  bool isUserAttendToday = await attendenceService
                      .isUserAttendToday(widget.loggedInUser!.id!);
                  if (isUserAttendToday) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You are already checked in"),
                        duration: Duration(seconds: 2)));
                  } else {
                    Attendence attendence = Attendence(
                      userId: widget.loggedInUser!.id!,
                      attendAt: DateTime.now(),
                      exactLocation: currentLocation.toString(),
                    );
                    await attendenceService.attendUser(attendence);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Checked in successfully"),
                        duration: Duration(seconds: 2)));
                  }
                } else {
                  // show dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'You are not in the zone, please make sure you are on it'),
                          actions: [
                            ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
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
