import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonateUs extends StatelessWidget {
  const DonateUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Palette.card,
            size: 36,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Donate Us",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light
                    ? Palette.textColor
                    : Palette.darkText,
              ),
            ),
            Image.asset(
              'images/bkash.jpg',
              height: 300,
              width: 300,
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(const ClipboardData(text: "+8801830676720"));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "+8801830676720",
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.textColor
                          : Palette.darkText,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(Icons.copy),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
