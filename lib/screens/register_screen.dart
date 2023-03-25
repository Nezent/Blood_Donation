import 'package:blood_connection/screens/home_screen.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../components/connection.dart';
import '../components/location_tracker.dart';
import '../components/register_data_model.dart';
import '../components/register_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
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
    List temporary_address = await _tracker.requestAddress();
    var temp_address = temporary_address.elementAt(0).split(' ');
    var short_address = temp_address[0].trim();
    address = "${short_address},${temporary_address.elementAt(1)}";
    latitude = double.parse(temporary_address.elementAt(2));
    longitude = double.parse(temporary_address.elementAt(3));
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Palette.cyan,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 27, 18, 16),
              child: Container(
                height: 59,
                width: 378,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Palette.card,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                    ),
                    indicator: BoxDecoration(
                      color: Palette.cyan,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    controller: tabController,
                    tabs: [
                      const Tab(
                        text: 'Sign In',
                      ),
                      const Tab(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Palette.newText,
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
                                      hintText: 'Enter your Phone Number',
                                      label: Text('Phone'),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 8),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your Password',
                                      label: Text('Password'),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_signIn.currentState!.validate()) {
                                        _logIn(numberController.text,
                                            passwordController.text);
                                      }
                                    },
                                    child: Container(
                                      height: 46,
                                      width: 340,
                                      decoration: BoxDecoration(
                                        color: Palette.cyan,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Log In',
                                          style: TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.card,
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
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Palette.newText,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => tabController
                                    .animateTo((tabController.index + 1) % 2),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.cyanText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Register as a Blood Donor',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Palette.newText,
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
                                    hintText: 'Enter your Name',
                                    label: Text('Name'),
                                    border: OutlineInputBorder(),
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
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your Phone Number',
                                    label: Text('Phone'),
                                    border: OutlineInputBorder(),
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
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter a Password',
                                    label: Text('Password'),
                                    border: OutlineInputBorder(),
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
                                    hintText: 'Re-type Password',
                                    label: Text('Confirm Password'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.outText,
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
                                      gender_type = value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  'Blood Type',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.outText,
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
                                      blood_type = value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: Container(
                                  height: 46,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Palette.cyan,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (_signUp.currentState!.validate()) {
                                          await _insertData(
                                            nameController.text,
                                            numberController.text,
                                            passwordCheckController.text,
                                            blood_type ?? "AB+",
                                            gender_type ?? "Male",
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.card,
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

  Future<void> _insertData(String name, String number, String password,
      String blood_type, String gender) async {
    final data = RegisterModel(
      name: name,
      bloodType: blood_type,
      number: number,
      password: password,
      gender: gender,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isAvailable: true,
    );
    var result = await MongoDB.register(data);
    _clearData();
  }

  void _clearData() {
    nameController.text = '';
    numberController.text = '';
    passwordController.text = '';
    passwordCheckController.text = '';
  }

  Future<void> _logIn(String number, String password) async {
    try {
      var userData = await MongoDB.logIn(number, password);
      var user = RegisterDataModel.fromJson(userData!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            id: user.id,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Data Found"),
        ),
      );
    }
  }
}
