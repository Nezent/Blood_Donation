import 'dart:async';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  MongoDB mongoDB = MongoDB();
  final _bloodType = ["AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"];
  String _currentSelectedValue = 'AB+';
  double? latitude;
  double? longitude;
  void _getAddress() async {
    LocationTracker _tracker = LocationTracker();
    List temporary_address = await _tracker.requestAddress();
    setState(() {
      latitude = double.parse(temporary_address.elementAt(2));
      longitude = double.parse(temporary_address.elementAt(3));
    });
  }

  void _connection() async {
    await MongoDB.connect();
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
    _connection();
    Timer.periodic(const Duration(seconds: 8), (timer) {
      mongoDB.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.cyan,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Palette.card,
            size: 36,
          ),
        ),
      ),
      body: StreamBuilder<dynamic>(
          stream: mongoDB.donorController.stream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Skeleton(height: 20, width: 130),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Skeleton(height: 20, width: 65),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Skeleton(
                              height: 80,
                              width: MediaQuery.of(context).size.width),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(17, 18, 0, 8),
                        child: Text(
                          'Blood Donors',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color: Palette.textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18, 17, 8),
                        child: Container(
                          height: 24,
                          width: 65,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Palette.textColor,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedValue,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _currentSelectedValue = newValue!;
                                    });
                                  },
                                  items: _bloodType.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 6,
                                        ),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Palette.textColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data =
                            RegisterDataModel.fromJson(snapshot.data[index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        return DonorList(
                          name: nickName,
                          number: data.number,
                          blood_type: data.bloodType,
                          address: data.address,
                          distance: Geolocator.distanceBetween(
                              data.latitude,
                              data.longitude,
                              latitude ?? 0.00,
                              longitude ?? 0.00),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'animations/not-found.json',
                      height: 240,
                      width: 240,
                      fit: BoxFit.fill,
                    ),
                    const Text(
                      "NO DATA FOUND",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Palette.cyanText),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
