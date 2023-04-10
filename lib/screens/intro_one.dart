import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroOne extends StatelessWidget {
  const IntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cyan,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset('animations/hello.json'),
            const Text(
              'WELCOME TO',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Palette.card),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'BLOOD CONNECTION',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Palette.card),
            ),
          ],
        ),
      ),
    );
  }
}
