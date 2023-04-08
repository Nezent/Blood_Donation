// ignore_for_file: library_prefixes

import 'dart:convert';

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class SideBar extends StatefulWidget {
  final Mongo.ObjectId? id;
  const SideBar({Key? key, required this.id}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Palette.cyan
          : Palette.darkSecondary,
      child: FutureBuilder(
          future: MongoDB.getUserData(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              var userData = RegisterDataModel.fromJson(snapshot.data!);
              final _controller = ValueNotifier<bool>(userData.isAvailable);
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
                          accountName: Text(userData.name),
                          accountEmail: Text(userData.number),
                          currentAccountPicture: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: CircleAvatar(
                              backgroundImage: userData.profilePicture == null
                                  ? const AssetImage("images/avatar.png")
                                  : Image.memory(base64Decode(
                                          userData.profilePicture!))
                                      .image,
                            ),
                          ),
                        ),
                        sideBarList("donates-white.svg", "Requests List", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RequestBloodScreen(),
                            ),
                          );
                        }),
                        sideBarList("blood-white.svg", "Donors List", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpScreen(),
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
                            controller: _controller,
                            height: 26,
                            width: 48,
                            activeColor: Palette.cyanText,
                            inactiveColor: Palette.cyanLight,
                            thumb: ValueListenableBuilder(
                                valueListenable: _controller,
                                builder: (BuildContext context, value, child) {
                                  MongoDB.changeAvailability(widget.id, value);
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: value
                                          ? Palette.cyan
                                          : Palette.cyanText,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        const Divider(),
                        sideBarList("cup-white.svg", "Buy Us a Ko-Fi", () {
                          Clipboard.setData(
                              const ClipboardData(text: "01830676720"));
                        }),
                        sideBarList("logout-white.svg", "Logout", () {
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
                        "Version: 1.0.0",
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
    return SizedBox(
      width: 120,
      child: Drawer(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: const Text("Anonymous"),
                    accountEmail: const Text(""),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Palette.cyanText
                            : Palette.darkWidget),
                    currentAccountPicture: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            "images/avatar.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  sideBarList("donates-white.svg", "Requests List", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestBloodScreen(),
                      ),
                    );
                  }),
                  sideBarList("blood-white.svg", "Donors List", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  }),
                  sideBarList("cup-white.svg", "Buy Us a Ko-Fi", () {
                    Clipboard.setData(const ClipboardData(text: "01830676720"));
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  "Version: 1.0.0",
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
        ),
      ),
    );
  }

  Widget sideBarList(String image, String title, VoidCallback tap) {
    return ListTile(
      leading: SvgPicture.asset(
        "images/${image}",
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
