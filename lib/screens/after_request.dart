import 'dart:async';

import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AfterRequest extends StatefulWidget {
  final mongo.ObjectId? id;
  const AfterRequest({super.key, required this.id});

  @override
  State<AfterRequest> createState() => _AfterRequestState();
}

class _AfterRequestState extends State<AfterRequest> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => (widget.id == null)
              ? const HomeScreen(
                  id: null,
                )
              : HomeScreen(id: widget.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'animations/syringe.json',
                  height: 240,
                  width: 240,
                  fit: BoxFit.fill,
                  reverse: true,
                ),
                Text(
                  "THANKS FOR THE",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyanText
                          : Palette.darkText),
                ),
                Text(
                  "REQUEST",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyanText
                          : Palette.darkText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
