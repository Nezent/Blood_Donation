import 'dart:async';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class HomeScreen extends StatefulWidget {
  final Mongo.ObjectId? id;
  const HomeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MongoDB mongoDB = MongoDB();
  final _bloodType = ["AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"];
  String _currentSelectedValue = 'AB+';
  double? latitude;
  double? longitude;
  // late StreamSubscription _subscription;

  // bool isDeviceConnected = false;
  String _base64 = "";
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

  Future<void> getPicture() async {
    try {
      if (widget.id != null) {
        var result = await MongoDB.getUserData(widget.id);
        if (RegisterDataModel.fromJson(result!).profilePicture != null) {
          _base64 = RegisterDataModel.fromJson(result).profilePicture!;
        }
      }
    } catch (_) {
      return;
    }
  }

  // void _getConnectivity() {
  //   try {
  //     _subscription = Connectivity()
  //         .onConnectivityChanged
  //         .listen((ConnectivityResult result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //     });
  //   } catch (_) {
  //     final SnackBar snackBar = SnackbarMessage("NO INTERNET!");
  //     snackbarKey.currentState?.showSnackBar(snackBar);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getPicture();
    _connection();
    _getAddress();
    mongoDB.getProfileData(widget.id);
    Timer.periodic(const Duration(seconds: 8), (timer) {
      mongoDB.getData();
      mongoDB.getUser();
    });
  }

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).brightness == Brightness.light
          ? Palette.cyan
          : Palette.darkSecondary,
    ));
    return Scaffold(
      drawer: SideBar(
        id: widget.id,
      ),
      body: SafeArea(
        child: StreamBuilder2(
          streams: StreamTuple2(
              mongoDB.requestController.stream, mongoDB.donorController.stream),
          builder: (context, SnapshotTuple2<dynamic, dynamic> snapshots) {
            if (snapshots.snapshot1.connectionState ==
                    ConnectionState.waiting &&
                snapshots.snapshot2.connectionState ==
                    ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Skeleton(
                        height: 54, width: MediaQuery.of(context).size.width),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Skeleton(height: 20, width: 130),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Skeleton(height: 90, width: 113),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Skeleton(height: 20, width: 130),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
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
            } else if (snapshots.snapshot1.hasData &&
                snapshots.snapshot2.hasData) {
              var totalRequests = snapshots.snapshot1.data!.length;
              var totalDonors = snapshots.snapshot2.data!.length;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(14.0),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.card
                                  : Palette.darkSecondary,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black12
                                  : Palette.newText.withOpacity(0.09),
                              blurRadius: 1.0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Builder(builder: (context) {
                                      return IconButton(
                                        splashRadius: 8.0,
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        icon: Icon(
                                          Icons.menu_outlined,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.newText
                                              : Palette.darkText,
                                          size: 24.0,
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      width: 16.9,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SearchScreen())),
                                        child: Text(
                                          'Search Blood',
                                          style: TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Palette.textColor
                                                    : Palette.darkText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.id != null
                                        ? ProfileScreen(
                                            id: widget.id,
                                          )
                                        : const RegisterScreen(),
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 16.0,
                                  backgroundImage:
                                      AssetImage('images/avatar.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                      child: Text(
                        'Our Partners',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.newText
                                  : Palette.darkText,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: SizedBox(
                        height: 90.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: Container(
                                height: 90.0,
                                width: 113.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Palette.cyanLight
                                      : Palette.darkSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                      child: Text(
                        'Blood Requests',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.newText
                                  : Palette.darkText,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var data = RequestDataModel.fromJson(
                            snapshots.snapshot1.data![index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        if (data.initBag == data.bag) {
                          _deleteRequest(data.id!);
                        }
                        return BloodRequest(
                          objectId: widget.id,
                          requestId: data.id!,
                          blood_type: data.bloodType,
                          name: nickName,
                          number: data.number,
                          bag: data.bag,
                          initBag: data.initBag,
                          address: data.address,
                          distance: Geolocator.distanceBetween(
                              data.latitude,
                              data.longitude,
                              latitude ?? 0.0,
                              longitude ?? 0.0),
                        );
                      },
                      childCount: totalRequests,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                          child: Text(
                            'Blood Donors',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.newText
                                  : Palette.darkText,
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
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Palette.newText
                                                  : Palette.darkText,
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
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var data = RegisterDataModel.fromJson(
                            snapshots.snapshot2.data![index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        return DonorList(
                          blood_type: data.bloodType,
                          name: nickName,
                          number: data.number,
                          address: data.address,
                          distance: Geolocator.distanceBetween(
                              data.latitude,
                              data.longitude,
                              latitude ?? 0.00,
                              longitude ?? 0.00),
                        );
                      },
                      childCount: totalDonors,
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
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.expand_less_outlined,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Color(0xff03DAC6),
        overlayColor: Colors.black38,
        overlayOpacity: 0.5,
        spacing: 8,
        spaceBetweenChildren: 4,
        children: [
          SpeedDialChild(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Palette.cyan
                : Palette.darkSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequestScreen(),
              ),
            ),
            child: SvgPicture.asset(
              "images/blood-white.svg",
              height: 24,
              width: 24,
            ),
            label: 'Request',
            labelStyle: const TextStyle(
              color: Palette.card,
            ),
            labelBackgroundColor: Palette.textColor,
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Palette.cyan
                : Palette.darkSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            ),
            child: SvgPicture.asset(
              "images/donates-white.svg",
              height: 24,
              width: 24,
            ),
            label: 'Donate',
            labelStyle: const TextStyle(
              color: Palette.card,
            ),
            labelBackgroundColor: Palette.textColor,
          ),
        ],
      ),
    );
  }

  void _deleteRequest(Mongo.ObjectId id) async {
    MongoDB.deleteRequest(id);
  }
}
