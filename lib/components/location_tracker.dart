import 'dart:async';

import 'package:blood_connection/main.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationTracker {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        barrierColor: const Color.fromARGB(168, 255, 255, 255),
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Allow location access"),
          content: const Text(
              "To show you how far you are from other users, we need access to your device's location. This feature helps you find and connect with other users nearby"),
          actions: [
            TextButton(
                child: const Text(
                  "Deny",
                  style: TextStyle(color: Palette.cyanText),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  // Reguest permission here
                  Geolocator.openLocationSettings();
                }),
            TextButton(
                child: const Text(
                  "Allow",
                  style: TextStyle(color: Palette.cyanText),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    // Permissions are denied, next time you could try
                    // requesting permissions again (this is also where
                    // Android's shouldShowRequestPermissionRationale
                    // returned true. According to Android guidelines
                    // your App should show an explanatory UI now.
                    await Geolocator.openLocationSettings();
                    return Future.error('Location services are disabled.');
                  }
                }),
          ],
        ),
      );
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: false);
  }

  Future<List> requestAddress() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "en");
    Placemark place = placemarks[0];
    double latitude = position.latitude;
    double longitude = position.longitude;
    List<String> requestAddress = [];
    requestAddress.add('${place.subAdministrativeArea}');
    requestAddress.add('${place.country}');
    requestAddress.add('$latitude');
    requestAddress.add('$longitude');
    String address =
        '${place.street}, ${place.locality}\n${place.subAdministrativeArea}, ${place.country}';
    requestAddress.add(address);
    return Future.value(requestAddress);
  }
}
