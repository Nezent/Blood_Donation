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
  LocationTracker _tracker = LocationTracker();
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
          backgroundColor: Palette.card,
          leading: IconButton(
            splashRadius: 8.0,
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
              size: 36,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18, 27, 18, 16),
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
                    labelStyle: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                    ),
                    indicator: BoxDecoration(
                      color: Palette.cardBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    controller: tabController,
                    tabs: [
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Palette.outText,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                child: TextFormField(
                                  controller: numberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
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
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Password',
                                    label: Text('Password'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    _logIn(numberController.text,
                                        passwordController.text);
                                  },
                                  child: Container(
                                    height: 46,
                                    width: 340,
                                    decoration: BoxDecoration(
                                      color: Palette.cardBackground,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.cardText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Palette.outText,
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
                                    color: Palette.text,
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
                        Text(
                          'Register as a Blood Donor',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Palette.outText,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 8),
                              child: TextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
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
                                controller: numberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
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
                                controller: passwordController,
                                decoration: InputDecoration(
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
                                controller: passwordCheckController,
                                decoration: InputDecoration(
                                  hintText: 'Re-type Password',
                                  label: Text('Password'),
                                  border: OutlineInputBorder(),
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
                                  color: Palette.outText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 55,
                              ),
                              child: Gender(
                                gender_type: (String value) {
                                  gender_type = value;
                                },
                              ),
                            ),
                            SizedBox(
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
                                  color: Palette.outText,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: SelectBlood(
                                blood_type: (String value) {
                                  blood_type = value;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Center(
                              child: Container(
                                height: 46,
                                width: 340,
                                decoration: BoxDecoration(
                                  color: Palette.cardBackground,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (passwordController.text ==
                                          passwordCheckController.text) {
                                        await _insertData(
                                          nameController.text,
                                          numberController.text,
                                          passwordCheckController.text,
                                          blood_type ?? "AB+",
                                          gender_type ?? "Male",
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Password Didn't Match!"),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.cardText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                          ],
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
