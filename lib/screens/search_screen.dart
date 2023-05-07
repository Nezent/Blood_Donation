// ignore_for_file: non_constant_identifier_names

import 'package:blood_connection/components/location_tracker.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationTracker _tracker = LocationTracker();
  String location = 'Null,tap button';
  String address = 'waiting';
  String? blood_type;
  String? request_address;

  void _getAddress() async {
    var tempAddress = await _tracker.requestAddress();
    var temp = tempAddress.elementAt(0).split(' ');
    var shortAddress = temp[0].trim();
    request_address = "$shortAddress,${tempAddress.elementAt(1)}";
    address = tempAddress.elementAt(4);
    if (mounted) {
      setState(() {});
    }
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
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 59),
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
                    color: Theme.of(context).brightness == Brightness.light
                        ? Palette.textColor
                        : Palette.darkText,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    height: 64,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.card
                          : Palette.darkSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: _tracker.requestAddress(),
                      builder: (context, snapshot) {
                        if (address == 'waiting') {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.cyanText
                                  : Palette.newText,
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              address,
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.outText
                                    : Palette.darkText,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }
                      },
                    )),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  splashColor: Palette.cyanLight,
                  onTap: () async {
                    _getAddress();
                  },
                  child: Container(
                    height: 40,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyan
                          : Palette.darkSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location_outlined,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.card
                                  : Palette.darkText,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Relocate',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.card
                                    : Palette.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Blood Type',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Palette.textColor
                        : Palette.darkText,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SelectBlood(
                  blood_type: (String value) {
                    blood_type = value;
                  },
                ),
              ],
            ),
            InkWell(
              splashColor: Palette.cyan,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonorScreen(
                    blood_type: blood_type ?? 'AB+',
                    address: request_address!,
                  ),
                ),
              ),
              child: Container(
                height: 46,
                width: 382,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Palette.cyan
                      : Palette.darkSecondary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.card
                          : Palette.darkText,
                    ),
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
