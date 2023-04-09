import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroTwo extends StatelessWidget {
  const IntroTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cyan,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'DISCOVER THE WORLD',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Palette.card),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: LottieBuilder.asset('animations/search.json'),
            ),
          ],
        ),
      ),
    );
  }
}
