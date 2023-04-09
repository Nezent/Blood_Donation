// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SelectBlood extends StatefulWidget {
  ValueChanged<String> blood_type;
  SelectBlood({Key? key, required this.blood_type}) : super(key: key);

  @override
  State<SelectBlood> createState() => _SelectBloodState();
}

class _SelectBloodState extends State<SelectBlood> {
  int selectedType = 0;
  Widget BloodType(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = index;
          widget.blood_type(text);
        });
      },
      child: Container(
        height: 38,
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),
          color: (selectedType == index
              ? (Theme.of(context).brightness == Brightness.light
                  ? Palette.cyan
                  : Palette.darkWidget)
              : (Theme.of(context).brightness == Brightness.light
                  ? Palette.cyanLight
                  : Palette.darkButton)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: (selectedType == index
                  ? (Theme.of(context).brightness == Brightness.light
                      ? Palette.card
                      : Palette.darkText)
                  : (Theme.of(context).brightness == Brightness.light
                      ? Palette.cyanText
                      : Palette.textColor)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('AB+', 0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('AB-', 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('A+', 2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('A-', 3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('B+', 4),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('B-', 5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('O+', 6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: BloodType('O-', 7),
            ),
          ],
        ),
      ],
    );
  }
}
