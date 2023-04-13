// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/profile_screen.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class EditProfile extends StatefulWidget {
  final mongo.ObjectId? id;
  final String name, number, password;
  const EditProfile(
      {super.key,
      required this.id,
      required this.name,
      required this.number,
      required this.password});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool editName = false;
  bool editPassword = false;
  final editProfile = GlobalKey<FormState>();
  late String address;
  late double latitude;
  late double longitude;
  final LocationTracker _tracker = LocationTracker();
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var passwordController = TextEditingController();
  var prevpasswordController = TextEditingController();
  var passwordCheckController = TextEditingController();
  bool isediting = false;

  void _getAddress() async {
    List temporaryAddress = await _tracker.requestAddress();
    var tempAddress = temporaryAddress.elementAt(0).split(' ');
    var shortAddress = tempAddress[0].trim();
    address = "$shortAddress,${temporaryAddress.elementAt(1)}";
    latitude = double.parse(temporaryAddress.elementAt(2));
    longitude = double.parse(temporaryAddress.elementAt(3));
  }

  void _connection() async {
    await MongoDB.connect();
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
    _connection();
    nameController.text = widget.name;
    numberController.text = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              Form(
                key: editProfile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      child: TextFormField(
                        style: const TextStyle(color: Palette.newText),
                        enabled: false,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^(?:\+88|88)?(01[3-9]\d{8})+$')
                                  .hasMatch(value)) {
                            return "Enter Valid Phone Number";
                          } else {
                            return null;
                          }
                        },
                        controller: numberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image.asset(
                              'images/bangladesh.png',
                              height: 16,
                              width: 16,
                            ),
                          ),
                          floatingLabelStyle:
                              const TextStyle(color: Palette.violet),
                          hintText: 'Enter your Phone Number',
                          label: const Text('Phone'),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.violet,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: CheckboxListTile(
                        activeColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Palette.cyanText
                                : Palette.darkSecondary,
                        title: Text(
                          "Edit Name",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: CheckboxListTile(
                        activeColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Palette.cyanText
                                : Palette.darkSecondary,
                        title: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.newText
                                    : Palette.darkText,
                          ),
                        ),
                        value: editPassword,
                        onChanged: (newValue) {
                          setState(() {
                            editPassword = !editPassword;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Visibility(
                      visible: editName ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Enter Correct Name";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            floatingLabelStyle:
                                TextStyle(color: Palette.violet),
                            hintText: 'Enter your Name',
                            label: Text('Name'),
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
                    Visibility(
                      visible: editPassword ? true : false,
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
                          obscureText: false,
                          controller: prevpasswordController,
                          decoration: const InputDecoration(
                            floatingLabelStyle:
                                TextStyle(color: Palette.violet),
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
                    Visibility(
                      visible: editPassword ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                    .hasMatch(value)) {
                              return "Must Contain Letters, Numbers & Special Characters";
                            } else {
                              return null;
                            }
                          },
                          obscureText: false,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            floatingLabelStyle:
                                TextStyle(color: Palette.violet),
                            hintText: 'Enter a Password',
                            label: Text('Password'),
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
                    Visibility(
                      visible: editPassword ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                value != passwordController.text) {
                              return "Password Didn't Match";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          controller: passwordCheckController,
                          decoration: const InputDecoration(
                            floatingLabelStyle:
                                TextStyle(color: Palette.violet),
                            hintText: 'Re-type Password',
                            label: Text('Confirm Password'),
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
                      visible: (editName || editPassword) ? true : false,
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              isediting = true;
                            });
                            if (editProfile.currentState!.validate()) {
                              if (editName && editPassword) {
                                _changeName(nameController.text);
                                _changePassword(passwordCheckController.text);
                              } else if (editName) {
                                _changeName(nameController.text);
                              } else {
                                _changePassword(passwordCheckController.text);
                              }
                            }
                            setState(() {
                              isediting = false;
                            });
                          },
                          child: Container(
                            height: 46,
                            width: 340,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.cyan
                                  : Palette.darkSecondary,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: isediting
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
      ),
    );
  }

  _changeName(String name) async {
    await MongoDB.changeName(widget.id, name);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ProfileScreen(id: widget.id)));
  }

  _changePassword(String password) async {
    await MongoDB.changePassword(widget.id, password);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ProfileScreen(id: widget.id)));
  }
}
