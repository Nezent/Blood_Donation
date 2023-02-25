import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String location = 'Null,tap button';
  String address = 'waiting';
  String? blood_type;
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: false);
  }

  Future<void> getAddress(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    address =
        '${place.subLocality}, ${place.locality}\n${place.subAdministrativeArea}, ${place.country}';
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPermission();
  }

  Future<void> _getPermission() async {
    Position position = await _determinePosition();
    location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    getAddress(position);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.card,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 36,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 59),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.outText,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                    height: 64,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Palette.card,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: _getPermission(),
                      builder: (context, snapshot) {
                        if (address == 'waiting') {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else {
                          return Center(
                            child: Text(
                              '$address',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w600,
                                color: Palette.outText,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }
                      },
                    )),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    address == 'waiting';
                    Position position = await _determinePosition();
                    location =
                        'Lat: ${position.latitude}, Long: ${position.longitude}';
                    getAddress(position);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Palette.cardBackground,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location_outlined,
                          color: Palette.cardText,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Relocate',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color: Palette.cardText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Blood Type',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.outText,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SelectBlood(
                  blood_type: (String value) {
                    blood_type = value;
                  },
                ),
              ],
            ),
            Container(
              height: 46,
              width: 382,
              decoration: BoxDecoration(
                color: Palette.cardBackground,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.cardText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
