import 'dart:async';

import 'package:blood_connection/screens/home_screen.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AfterFeedback extends StatefulWidget {
  final mongo.ObjectId? id;
  const AfterFeedback({super.key, required this.id});

  @override
  State<AfterFeedback> createState() => _AfterFeedbackState();
}

class _AfterFeedbackState extends State<AfterFeedback> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => widget.id != null
              ? HomeScreen(
                  id: widget.id,
                )
              : const HomeScreen(id: null),
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
                  'animations/feedback.json',
                  height: 240,
                  width: 300,
                  fit: BoxFit.fill,
                  reverse: true,
                ),
                const SizedBox(
                  height: 16,
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
                  "THE FEEDBACK",
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
