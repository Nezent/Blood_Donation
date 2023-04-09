import 'dart:async';

import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AfterUnitsAdd extends StatefulWidget {
  final mongo.ObjectId? id;
  const AfterUnitsAdd({super.key, required this.id});

  @override
  State<AfterUnitsAdd> createState() => _AfterUnitsAddState();
}

class _AfterUnitsAddState extends State<AfterUnitsAdd> {
  @override
  void initState() {
    var id = widget.id;
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => UserRequestScreen(
            donations: const [],
            id: id,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'animations/donate.json',
                height: 240,
                width: 240,
                fit: BoxFit.fill,
                reverse: true,
              ),
              Text(
                "THANK YOU FOR",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Palette.cyanText
                        : Palette.darkText),
              ),
              Text(
                "DONATION",
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
    );
  }
}
