import 'dart:async';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:blood_connection/widgets/request.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RequestBloodScreen extends StatefulWidget {
  final mongo.ObjectId? objectId;
  const RequestBloodScreen({super.key, required this.objectId});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  double? latitude;
  double? longitude;
  MongoDB mongoDB = MongoDB();
  @override
  void initState() {
    super.initState();
    _connection();
    _getAddress();
    Timer.periodic(const Duration(seconds: 8), (timer) {
      mongoDB.getData();
    });
  }

  void _connection() async {
    await MongoDB.connect();
  }

  void _getAddress() async {
    LocationTracker tracker = LocationTracker();
    List? temporaryAddress = await tracker.requestAddress();
    setState(() {
      latitude = double.parse(temporaryAddress.elementAt(2));
      longitude = double.parse(temporaryAddress.elementAt(3));
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      body: SafeArea(
        child: StreamBuilder(
            stream: mongoDB.requestController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Palette.cyanText
                        : Palette.newText,
                  ),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        var data =
                            RequestDataModel.fromJson(snapshot.data![index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        if (data.initBag == data.bag) {
                          _deleteRequest(data.id!);
                        }
                        if ((Geolocator.distanceBetween(
                                    data.latitude,
                                    data.longitude,
                                    latitude ?? 0.00,
                                    longitude ?? 0.00) /
                                1000) <=
                            20) {
                          return BloodRequest(
                            objectId: widget.objectId,
                            requestId: data.id!,
                            blood_type: data.bloodType,
                            name: nickName,
                            number: nickName,
                            bag: data.bag,
                            initBag: data.initBag,
                            address: data.address,
                            distance: Geolocator.distanceBetween(
                                data.latitude,
                                data.longitude,
                                latitude ?? 0.00,
                                longitude ?? 0.00),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
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
            }),
      ),
    );
  }

  void _deleteRequest(mongo.ObjectId id) async {
    MongoDB.deleteRequest(id);
  }
}
