import 'dart:async';

import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AfterRequest extends StatefulWidget {
  const AfterRequest({super.key});

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
          builder: (BuildContext context) => const HomeScreen(
            id: null,
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
    );
  }
}
