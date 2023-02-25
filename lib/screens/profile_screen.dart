import 'package:flutter/material.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';

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
          style: TextStyle(color: Palette.cardText),
        ),
        centerTitle: true,
        backgroundColor: Palette.card,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 36,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
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
                        border:
                            Border.all(color: Palette.cardBackground, width: 2),
                      ),
                      child: Center(
                        child: Image.asset("images/camera.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            ProfileWidget(icon: "user.png", text: "My Profile"),
            SizedBox(
              height: 12,
            ),
            ProfileWidget(icon: "bell-ring.png", text: "Notifications"),
            SizedBox(
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
                                  child: Image.asset("images/blood-drop.png"),
                                ),
                              ),
                              SizedBox(
                                width: 32,
                              ),
                              Text(
                                "Availability",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.text,
                                ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
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
            SizedBox(
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
                                  child: Image.asset("images/night-mode.png"),
                                ),
                              ),
                              SizedBox(
                                width: 32,
                              ),
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.text,
                                ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
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
            SizedBox(
              height: 12,
            ),
            ProfileWidget(icon: "setting.png", text: "Settings"),
            SizedBox(
              height: 12,
            ),
            ProfileWidget(icon: "question-mark.png", text: "Help Center"),
          ],
        ),
      ),
    );
  }
}
