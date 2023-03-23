import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../components/location_tracker.dart';
import '../components/register_data_model.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
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

  @override
  void initState() {
    super.initState();
    _getAddress();
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
      body: FutureBuilder(
          future: MongoDB.getUser(),
          builder: (context, AsyncSnapshot snapshot) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                      child: Text(
                        'Blood Donors',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.outText,
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
                            color: Palette.outText,
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
                                        style: TextStyle(
                                          color: Palette.outText,
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
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        var data =
                            RegisterDataModel.fromJson(snapshot.data[index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        if (data.isAvailable) {
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
                        }
                      } else {
                        return Center(
                          child: Text("No Data Found"),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
