// ignore_for_file: library_prefixes, use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  final Mongo.ObjectId? id;
  const SideBar({Key? key, required this.id}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String version = '1.0';
  String buildNumber = '1';
  _packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  void initState() {
    super.initState();
    _packageInfo();
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
                              backgroundImage: userData.profilePicture == null
                                  ? const AssetImage("images/bot.png")
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
                          Clipboard.setData(
                              const ClipboardData(text: "01830676720"));
                        }),
                        sideBarList("logout-white.svg", "Logout", () async {
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
                    accountName: const Text(
                      "Nezent Bot",
                      style: TextStyle(fontSize: 18),
                    ),
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
                            "images/bot.png",
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
        ),
      ),
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
