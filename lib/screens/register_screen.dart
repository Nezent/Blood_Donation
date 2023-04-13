// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool isLogin = false;
  final _signIn = GlobalKey<FormState>();
  final _signUp = GlobalKey<FormState>();
  final LocationTracker _tracker = LocationTracker();
  late String address;
  late double latitude;
  late double longitude;
  String? blood_type;
  String? gender_type;
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordCheckController = TextEditingController();
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

  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    _connection();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Palette.cyan
              : Palette.darkSecondary,
          leading: IconButton(
            splashRadius: 8.0,
            onPressed: () => Navigator.push(
              context,
              PageTransition(
                  child: const HomeScreen(id: null),
                  type: PageTransitionType.leftToRight),
            ),
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Palette.card,
              size: 36,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 27, 18, 16),
              child: Container(
                height: 59,
                width: 378,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Palette.card
                      : Palette.darkSecondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    labelColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Palette.darkText,
                    labelStyle: const TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                    ),
                    indicator: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyan
                          : Palette.darkWidget,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: 'Sign In',
                      ),
                      Tab(
                        text: 'Sign Up',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.newText
                                    : Palette.darkText,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Form(
                              key: _signIn,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 8),
                                    child: TextFormField(
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
                                      decoration: const InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: Palette.violet),
                                        hintText: 'Enter your Phone Number',
                                        label: Text('Phone'),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 8),
                                    child: TextFormField(
                                      obscureText: _obscureText,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        floatingLabelStyle: const TextStyle(
                                            color: Palette.violet),
                                        hintText: 'Enter your Password',
                                        label: const Text('Password'),
                                        suffixIcon: IconButton(
                                            color: Palette.cyan,
                                            splashRadius: 16,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            icon: Icon(_obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility)),
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.newText
                                              : Palette.darkText,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgetPassword(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Palette.cyanText
                                                    : Palette.darkWidget,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          isLogin = true;
                                        });
                                        if (_signIn.currentState!.validate()) {
                                          await _logIn(numberController.text,
                                              passwordController.text);
                                        }

                                        setState(() {
                                          isLogin = false;
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
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Center(
                                          child: isLogin
                                              ? const JumpingDots(
                                                  radius: 8,
                                                  color: Palette.card,
                                                  animationDuration: Duration(
                                                      milliseconds: 200),
                                                  numberOfDots: 3,
                                                )
                                              : Text(
                                                  'Log In',
                                                  style: TextStyle(
                                                    fontSize: 19.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Palette.card
                                                        : Palette.darkText,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Palette.newText
                                        : Palette.darkText,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => tabController
                                      .animateTo((tabController.index + 1) % 2),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Palette.cyanText
                                          : Palette.darkWidget,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Register as a Blood Donor',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.newText
                                    : Palette.darkText,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _signUp,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                child: TextFormField(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
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
                                  obscureText: _obscureText,
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
                              Padding(
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Palette.outText
                                        : Palette.darkText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 55,
                                ),
                                child: Center(
                                  child: Gender(
                                    gender_type: (String value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      gender_type = value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Blood Type',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Palette.outText
                                        : Palette.darkText,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Center(
                                  child: SelectBlood(
                                    blood_type: (String value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      blood_type = value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (_signUp.currentState!.validate()) {
                                      _checkUser(numberController.text);
                                    }
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
                                      child: Text(
                                        'Register',
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
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logIn(String number, String password) async {
    try {
      var userData = await MongoDB.logIn(number, password);

      if (userData != null) {
        var user = RegisterDataModel.fromJson(userData);
        // Shared Preferences
        SharedPreferences session = await SharedPreferences.getInstance();
        await session.setString('objectId', user.id!.toHexString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              id: user.id,
            ),
          ),
        );
      } else {
        final SnackBar snackBar =
            SnackbarMessage("TypeError: Fields didn't Match!");
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("Error: No Data Found!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> _checkUser(String number) async {
    try {
      var userData = await MongoDB.checkUserData(number);
      if (userData == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ValidationScreen(
              address: address,
              blood_type: blood_type ?? "AB+",
              gender: gender_type ?? "Male",
              latitude: latitude,
              longitude: longitude,
              name: nameController.text,
              number: numberController.text,
              password: passwordController.text,
            ),
          ),
        );
      } else {
        final SnackBar snackBar = SnackbarMessage("USER ALREADY EXISTS!");
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("USER ALREADY EXISTS!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
