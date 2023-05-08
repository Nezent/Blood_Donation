// ignore_for_file: library_prefixes, use_build_context_synchronously

import 'dart:io';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SideBar extends StatefulWidget {
  final Mongo.ObjectId? id;
  const SideBar({Key? key, required this.id}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String version = '1.0';
  String buildNumber = '1';
  String? model;
  String? name;
  _packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  void findModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      name = androidInfo.id;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = iosInfo.utsname.machine!;
      name = iosInfo.utsname.sysname!;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _packageInfo();
    findModel();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color.fromARGB(224, 0, 149, 144)
          : const Color.fromARGB(224, 31, 31, 31),
      child: FutureBuilder(
          future: MongoDB.getUserData(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator.adaptive(
                backgroundColor: Palette.card,
              ));
            } else if (snapshot.hasData) {
              var userData = RegisterDataModel.fromJson(snapshot.data!);
              final controller = ValueNotifier<bool>(userData.isAvailable);
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.cyanText
                                  : Palette.darkWidget),
                          accountName: Text(
                            userData.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          accountEmail: Text(
                            userData.number,
                            style: const TextStyle(fontSize: 18),
                          ),
                          currentAccountPicture: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: CircleAvatar(
                              backgroundColor: Palette.background,
                              backgroundImage: userData.profilePicture == null
                                  ? const AssetImage("images/user.png")
                                  : Image.network(userData.profilePicture!)
                                      .image,
                            ),
                          ),
                        ),
                        sideBarList("donates-white.svg", "Requests List", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestBloodScreen(
                                objectId: widget.id,
                              ),
                            ),
                          );
                        }),
                        const Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            "images/blood-tube-white.svg",
                            height: 24,
                            width: 24,
                          ),
                          title: Text(
                            "Availibility",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.card
                                  : Palette.darkText,
                            ),
                          ),
                          trailing: AdvancedSwitch(
                            controller: controller,
                            height: 26,
                            width: 48,
                            activeColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.cyanText
                                    : Palette.darkWidget,
                            inactiveColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.cyanLight
                                    : Palette.textColor,
                            thumb: ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (BuildContext context, value, child) {
                                  MongoDB.changeAvailability(widget.id, value);
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: value
                                          ? Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.card
                                              : Palette.card
                                          : Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.card
                                              : Palette.card,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        const Divider(),
                        sideBarList("question-mark-white.svg", "Help Center",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpScreen(
                                id: widget.id,
                              ),
                            ),
                          );
                        }),
                        sideBarList("cup-white.svg", "Buy Us a Ko-Fi", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonateUs(),
                            ),
                          );
                        }),
                        sideBarList("star.svg", "Rate Us", () async {
                          await launchUrlString(
                              "https://play.google.com/store/apps/details?id=com.nezent.BloodConnection");
                        }),
                        sideBarList("logout.svg", "Logout", () async {
                          SharedPreferences session =
                              await SharedPreferences.getInstance();
                          await session.remove('objectId');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen(id: null)));
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        "Version: $version",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.card
                                  : Palette.darkText,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return _defaultData();
            }
          }),
    );
  }

  Widget _defaultData() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  model ?? "Unknown",
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(
                  name ?? "Unknown",
                  style: const TextStyle(fontSize: 18),
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Palette.cyanText
                        : Palette.darkWidget),
                currentAccountPicture: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Palette.cyan
                            : Palette.darkSecondary,
                    child: ClipOval(
                      child: Text(
                        model![0],
                        style: TextStyle(
                          fontSize: 36,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.card
                                  : Palette.newText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              sideBarList("donates-white.svg", "Requests List", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestBloodScreen(
                      objectId: widget.id,
                    ),
                  ),
                );
              }),
              sideBarList("question-mark-white.svg", "Help Center", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpScreen(
                      id: null,
                    ),
                  ),
                );
              }),
              sideBarList("cup-white.svg", "Buy Us a Ko-Fi", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonateUs(),
                  ),
                );
              }),
              sideBarList("star.svg", "Rate Us", () async {
                await launchUrlString(
                    "https://play.google.com/store/apps/details?id=com.nezent.BloodConnection");
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text(
              "Version: $version",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light
                    ? Palette.card
                    : Palette.darkText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sideBarList(String image, String title, VoidCallback tap) {
    return ListTile(
      leading: SvgPicture.asset(
        "images/$image",
        height: 24,
        width: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).brightness == Brightness.light
              ? Palette.card
              : Palette.darkText,
        ),
      ),
      onTap: tap,
    );
  }
}
