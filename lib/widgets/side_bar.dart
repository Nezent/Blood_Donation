// ignore_for_file: library_prefixes

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/register_data_model.dart';
import 'package:blood_connection/screens/donor_screen.dart';
import 'package:blood_connection/screens/home_screen.dart';
import 'package:blood_connection/screens/request_blood_screen.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Palette.cyan,
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
                          decoration:
                              const BoxDecoration(color: Palette.cyanText),
                          accountName: Text(userData.name),
                          accountEmail: Text(userData.number),
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
                        ListTile(
                          leading: SvgPicture.asset("images/donates-white.svg"),
                          title: const Text(
                            "Requests List",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RequestBloodScreen(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            "images/blood-white.svg",
                            height: 24,
                            width: 24,
                          ),
                          title: const Text(
                            "Donors List",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonorScreen(),
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            "images/blood-tube-white.svg",
                            height: 24,
                            width: 24,
                          ),
                          title: const Text(
                            "Availibility",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
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
                        ListTile(
                          leading: SvgPicture.asset("images/cup-white.svg"),
                          title: const Text(
                            "Buy Us a Ko-Fi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: SvgPicture.asset("images/logout-white.svg"),
                          title: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen(id: null))),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        "Version: 1.0.0",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Palette.card,
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
        backgroundColor: Palette.cyan,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: const Text("Anonymous"),
                    accountEmail: const Text(""),
                    decoration: const BoxDecoration(color: Palette.cyanText),
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
                  ListTile(
                    leading: SvgPicture.asset("images/donates-white.svg"),
                    title: const Text(
                      "Requests List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Palette.card,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestBloodScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "images/blood-white.svg",
                      height: 24,
                      width: 24,
                    ),
                    title: const Text(
                      "Donors List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Palette.card,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonorScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset("images/cup-white.svg"),
                    title: const Text(
                      "Buy Us a Ko-Fi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Palette.card,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  "Version: 1.0.0",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Palette.card,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
