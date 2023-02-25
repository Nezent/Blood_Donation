import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Anon"),
            accountEmail: Text("01747438603"),
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
            title: Text("Listing"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bloodtype_sharp),
            title: Text("Availibility"),
            trailing: Switch.adaptive(
                value: value,
                onChanged: (bool newValue) {
                  setState(() {
                    value = newValue;
                  });
                }),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
