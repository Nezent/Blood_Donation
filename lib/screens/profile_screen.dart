import 'package:flutter/material.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool newValue = false, dark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Palette.card),
        ),
        centerTitle: true,
        backgroundColor: Palette.cyan,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      "images/avatar.png",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 36.0,
                      width: 36.0,
                      decoration: BoxDecoration(
                        color: Palette.background,
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                        border: Border.all(color: Palette.cyanText, width: 2),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "images/camera.svg",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const ProfileWidget(icon: "user.svg", text: "My Profile"),
            const SizedBox(
              height: 12,
            ),
            const ProfileWidget(
                icon: "notifications.svg", text: "Notifications"),
            const SizedBox(
              height: 12,
            ),
            Padding(
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
                  boxShadow: const [
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
                                  child: SvgPicture.asset(
                                    "images/drop-of-blood.svg",
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              const Text(
                                "Availability",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.newText,
                                ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
                              activeColor: Palette.cyanText,
                              activeTrackColor: Palette.cyan,
                              inactiveThumbColor: Palette.cyanLight,
                              inactiveTrackColor: Palette.cyan,
                              value: newValue,
                              onChanged: (bool value) {
                                setState(() {
                                  newValue = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
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
                  boxShadow: const [
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
                                  child: SvgPicture.asset(
                                    "images/night-mode.svg",
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              const Text(
                                "Dark Mode",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.newText,
                                ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
                              activeColor: Palette.cyanText,
                              activeTrackColor: Palette.cyan,
                              inactiveThumbColor: Palette.cyanLight,
                              inactiveTrackColor: Palette.cyan,
                              value: dark,
                              onChanged: (bool value) {
                                setState(() {
                                  dark = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const ProfileWidget(icon: "settings.svg", text: "Settings"),
            const SizedBox(
              height: 12,
            ),
            const ProfileWidget(icon: "help.svg", text: "Help Center"),
          ],
        ),
      ),
    );
  }
}
