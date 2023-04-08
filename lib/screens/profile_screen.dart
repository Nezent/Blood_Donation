import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  final Mongo.ObjectId? id;
  const ProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  void _getImage() async {
    String url = "";
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // Uint8List imageByte = await image.readAsBytes();
    url = "";
    if (url != "") {
      MongoDB.changeProfilePicture(widget.id, url);
    }
  }

  Widget showImage(BuildContext context, String? value) {
    return ClipOval(
      child: Image.network(
        "",
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Palette.card
                  : Palette.darkText),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 30, 29, 29),
                      highlightColor: const Color.fromARGB(146, 238, 238, 233),
                      child: Container(
                        height: 124,
                        width: 124,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.04),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Skeleton(height: 32, width: 240),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Skeleton(
                            height: 64,
                            width: MediaQuery.of(context).size.width),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            var userData = RegisterDataModel.fromJson(snapshot.data!);
            final _controller = ValueNotifier<bool>(userData.isAvailable);

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
                              _getImage();
                            },
                            child: Container(
                              height: 36.0,
                              width: 36.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.background
                                    : Palette.darkSecondary,
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
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.textColor
                                    : Palette.darkText,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ProfileWidget(
                    icon: "user.svg",
                    text: "My Profile",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(id: widget.id)));
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileWidget(
                    icon: "donation-heart.svg",
                    text: "My Donations",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserRequestScreen(
                                    donations: userData.donations,
                                    id: widget.id,
                                  )));
                    },
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Palette.card
                            : Palette.darkSecondary,
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
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.background
                                            : Palette.darkWidget,
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
                                    Text(
                                      "Availability",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.newText
                                            : Palette.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                                AdvancedSwitch(
                                  controller: _controller,
                                  height: 26,
                                  width: 48,
                                  activeColor: Palette.cyanText,
                                  inactiveColor: Palette.cyan,
                                  thumb: ValueListenableBuilder(
                                      valueListenable: _controller,
                                      builder:
                                          (BuildContext context, value, child) {
                                        MongoDB.changeAvailability(
                                            widget.id, value);
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: Palette.card,
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Palette.card
                            : Palette.darkSecondary,
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
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.background
                                            : Palette.darkWidget,
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
                                    Text(
                                      "Dark Mode",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.newText
                                            : Palette.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                                Consumer<ThemeManager>(
                                  builder: (context, provider, child) {
                                    return FlutterSwitch(
                                        height: 26,
                                        width: 48,
                                        padding: 1.8,
                                        toggleSize: 23,
                                        activeColor: Palette.cyanText,
                                        inactiveColor: Palette.cyan,
                                        value: provider.themeMode ==
                                            ThemeMode.dark,
                                        onToggle: (bool value) {
                                          setState(() {
                                            provider.toggleTheme(value);
                                          });
                                        });
                                  },
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
                  ProfileWidget(
                    icon: "settings.svg",
                    text: "Settings",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(id: widget.id)));
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileWidget(
                      icon: "help.svg",
                      text: "Help Center",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelpScreen()));
                      }),
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
