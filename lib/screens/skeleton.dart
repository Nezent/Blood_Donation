import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double height, width;
  const Skeleton({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).brightness == Brightness.light
            ? const Color.fromARGB(255, 54, 52, 52)
            : const Color.fromARGB(255, 64, 63, 63),
        highlightColor: Theme.of(context).brightness == Brightness.light
            ? const Color.fromARGB(255, 171, 171, 168)
            : const Color.fromARGB(248, 113, 111, 111),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.08)
                : Colors.white54,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
