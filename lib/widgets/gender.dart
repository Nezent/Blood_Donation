import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  ValueChanged<String> gender_type;
  Gender({Key? key, required this.gender_type}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  int selectedGender = 0;
  Widget GenderType(var icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = index;
          widget.gender_type(text);
        });
      },
      child: Container(
        height: 38,
        width: 132,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),
          color: (selectedGender == index
              ? Palette.cardText
              : Palette.cardBackground),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color:
                    (selectedGender == index ? Palette.card : Palette.outText),
              ),
            ),
          ],
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
              child: GenderType(Icons.male_outlined, 'Male', 0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: GenderType(Icons.female_outlined, 'Female', 1),
            ),
          ],
        ),
      ],
    );
  }
}
