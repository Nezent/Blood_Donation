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

  void _getAddress() async {
    var temp_address = await _tracker.requestAddress();
    address = temp_address.elementAt(4);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 59),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.textColor,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    height: 64,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Palette.card,
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
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else {
                          return Center(
                            child: Text(
                              '$address',
                              style: const TextStyle(
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
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  splashColor: Palette.cyanLight,
                  onTap: () async {
                    var temp_address = await _tracker.requestAddress();
                    address = temp_address.elementAt(4);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 382,
                    decoration: BoxDecoration(
                      color: Palette.cyan,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.my_location_outlined,
                          color: Palette.card,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Relocate',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color: Palette.card,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Blood Type',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.textColor,
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
                  builder: (context) => const DonorScreen(),
                ),
              ),
              child: Container(
                height: 46,
                width: 382,
                decoration: BoxDecoration(
                  color: Palette.cyan,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Palette.card,
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
