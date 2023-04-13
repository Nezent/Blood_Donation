// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final mongo.ObjectId? id;
  final String password;
  const Settings({super.key, required this.id, required this.password});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDeleting = false;
  bool editName = false;
  final deleteProfile = GlobalKey<FormState>();
  var prevpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Palette.card,
            size: 36,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            Form(
              key: deleteProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    activeColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Palette.cyanText
                            : Palette.darkSecondary,
                    title: Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Palette.newText
                            : Palette.darkText,
                      ),
                    ),
                    value: editName,
                    onChanged: (newValue) {
                      setState(() {
                        editName = !editName;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Visibility(
                    visible: editName ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value != widget.password) {
                            return "Password is not Correct!";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        controller: prevpasswordController,
                        decoration: const InputDecoration(
                          floatingLabelStyle: TextStyle(color: Palette.violet),
                          hintText: 'Enter Previous Password',
                          label: Text('Prev Password'),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.violet,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Visibility(
                    visible: (editName) ? true : false,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            isDeleting = true;
                          });
                          if (deleteProfile.currentState!.validate()) {
                            _deleteUser();
                          }
                          setState(() {
                            isDeleting = false;
                          });
                        },
                        child: Container(
                          height: 46,
                          width: 340,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.cyan
                                    : Palette.darkSecondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: isDeleting
                                ? const JumpingDots(
                                    color: Palette.card,
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    radius: 8,
                                    numberOfDots: 3,
                                  )
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Palette.card
                                          : Palette.darkText,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteUser() async {
    await MongoDB.deleteUser(widget.id);
    SharedPreferences session = await SharedPreferences.getInstance();
    await session.remove('objectId');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const HomeScreen(id: null)));
  }
}
