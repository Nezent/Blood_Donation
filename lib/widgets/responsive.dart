import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobileMax;
  final Widget mobileMin;
  final Widget tablet;
  const Responsive(
      {Key? key,
      required this.mobileMax,
      required this.mobileMin,
      required this.tablet})
      : super(key: key);

  static bool isMobileMax(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 800;

  static bool isMobileMin(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isMobileTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return tablet;
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 800) {
          return mobileMax;
        } else {
          return mobileMin;
        }
      },
    );
  }
}
