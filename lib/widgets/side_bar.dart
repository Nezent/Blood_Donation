import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/register_data_model.dart';
import 'package:blood_connection/screens/donor_screen.dart';
import 'package:blood_connection/screens/home_screen.dart';
import 'package:flutter/material.dart';
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
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Favourite"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text("Donor List"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonorScreen(),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.bloodtype_sharp),
                    title: Text("Availibility"),
                    trailing: Switch.adaptive(
                        value: userData.isAvailable,
                        onChanged: (bool newValue) {
                          MongoDB.changeAvailability(widget.id, newValue);
                        }),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Logout"),
                    onTap: () {},
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Anonymous"),
            accountEmail: Text("01XXXXXXXXX"),
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
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favourite"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Donor List"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonorScreen(),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(id: null))),
          ),
        ],
      ),
    );
  }
}
