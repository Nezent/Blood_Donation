// ignore_for_file: library_prefixes

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/register_data_model.dart';
import 'package:blood_connection/screens/donor_screen.dart';
import 'package:blood_connection/screens/home_screen.dart';
import 'package:blood_connection/screens/request_blood_screen.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class SideBar extends StatefulWidget {
  final Mongo.ObjectId? id;
  const SideBar({Key? key, required this.id}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.cyanLight,
      child: FutureBuilder(
          future: MongoDB.getUserData(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              var userData = RegisterDataModel.fromJson(snapshot.data!);

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Palette.cyanText),
                    accountName: Text(userData.name),
                    accountEmail: Text(userData.number),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          "images/avatar.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset("images/homes.svg"),
                    title: const Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: SvgPicture.asset("images/donate-blood.svg"),
                    title: const Text("Requests List"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestBloodScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "images/donors.svg",
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Donors List"),
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
                      "images/blood-test.svg",
                      height: 24,
                      width: 24,
                    ),
                    title: const Text("Availibility"),
                    trailing: Switch.adaptive(
                        activeColor: Palette.cyanText,
                        activeTrackColor: Palette.cyan,
                        inactiveThumbColor: Palette.cyanLight,
                        inactiveTrackColor: Palette.cyan,
                        value: userData.isAvailable,
                        onChanged: (bool newValue) {
                          MongoDB.changeAvailability(widget.id, newValue);
                        }),
                  ),
                  const Divider(),
                  ListTile(
                    leading: SvgPicture.asset("images/logout.svg"),
                    title: const Text("Logout"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen(id: null))),
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
        backgroundColor: Palette.cyanLight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Anonymous"),
              accountEmail: const Text("01XXXXXXXXX"),
              decoration: const BoxDecoration(color: Palette.cyanText),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    "images/avatar.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset("images/homes.svg"),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("images/donate-blood.svg"),
              title: const Text("Requests List"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestBloodScreen(),
                ),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                "images/donors.svg",
                height: 24,
                width: 24,
              ),
              title: const Text("Donors List"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DonorScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
