import 'dart:convert';
import 'dart:typed_data';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/register_data_model.dart';
import 'package:blood_connection/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class ProfileScreen extends StatefulWidget {
  final Mongo.ObjectId? id;
  const ProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  void _getImageBase64() async {
    String _base64 = "";
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Uint8List imageByte = await image.readAsBytes();
    _base64 = base64Encode(imageByte);
    if (_base64 != "") {
      MongoDB.changeProfilePicture(widget.id, _base64);
    }
  }

  Widget showImage(BuildContext context, String? value) {
    return ClipOval(
      child: Image.memory(
        base64Decode(value!),
        fit: BoxFit.cover,
      ),
    );
  }

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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(id: widget.id),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Palette.card,
            size: 36,
          ),
        ),
      ),
      body: FutureBuilder(
        future: MongoDB.getUserData(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("waiting"),
            );
          } else if (snapshot.hasData) {
            var userData = RegisterDataModel.fromJson(snapshot.data!);
            final _controller = ValueNotifier<bool>(userData.isAvailable);
            final _themeController = ValueNotifier<bool>(userData.isDark);
            return SingleChildScrollView(
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
                        userData.profilePicture != null
                            ? showImage(context, userData.profilePicture)
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "images/avatar.png",
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _getImageBase64();
                            },
                            child: Container(
                              height: 36.0,
                              width: 36.0,
                              decoration: BoxDecoration(
                                color: Palette.background,
                                borderRadius: BorderRadius.circular(
                                  50.0,
                                ),
                                border: Border.all(
                                    color: Palette.cyanText, width: 2),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        userData.name,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Palette.textColor,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
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
                                AdvancedSwitch(
                                  controller: _controller,
                                  height: 26,
                                  width: 48,
                                  activeColor: Palette.cyanText,
                                  inactiveColor: Palette.cyanLight,
                                  thumb: ValueListenableBuilder(
                                      valueListenable: _controller,
                                      builder:
                                          (BuildContext context, value, child) {
                                        MongoDB.changeAvailability(
                                            widget.id, value);
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: value
                                                ? Palette.cyan
                                                : Palette.cyanText,
                                          ),
                                        );
                                      }),
                                ),
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
                                AdvancedSwitch(
                                  controller: _themeController,
                                  height: 26,
                                  width: 48,
                                  activeColor: Palette.cyanText,
                                  inactiveColor: Palette.cyanLight,
                                  thumb: ValueListenableBuilder(
                                      valueListenable: _themeController,
                                      builder:
                                          (BuildContext context, value, child) {
                                        MongoDB.changeTheme(widget.id, value);
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: value
                                                ? Palette.cyan
                                                : Palette.cyanText,
                                          ),
                                        );
                                      }),
                                ),
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
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'animations/not-found.json',
                    height: 240,
                    width: 240,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
