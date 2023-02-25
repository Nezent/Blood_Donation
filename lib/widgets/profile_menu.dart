import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String icon, text;
  const ProfileWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 17.0,
      ),
      child: Container(
        height: 64.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Palette.card,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Palette.background,
                          borderRadius: BorderRadius.circular(
                            31.0,
                          ),
                        ),
                        child: Center(
                          child: Image.asset("images/$icon"),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.text,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Palette.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
