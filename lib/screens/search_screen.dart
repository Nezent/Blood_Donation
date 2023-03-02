import 'package:blood_connection/components/location_tracker.dart';
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

  void _getAddress() async {
    address = await _tracker.getAddress();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
                      future: _tracker.getAddress(),
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
                    address = await _tracker.getAddress();
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
