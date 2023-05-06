import 'dart:async';

import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AfterDonation extends StatefulWidget {
  const AfterDonation({super.key});

  @override
  State<AfterDonation> createState() => _AfterDonationState();
}

class _AfterDonationState extends State<AfterDonation> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const RegisterScreen(
            prevScreen: "AfterDonation",
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
                "JOINING US",
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
