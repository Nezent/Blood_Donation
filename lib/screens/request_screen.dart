// ignore_for_file: non_constant_identifier_names

import 'package:blood_connection/components/connection.dart';
import 'package:blood_connection/components/location_tracker.dart';
import 'package:blood_connection/screens/request_validation_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/widgets/widgets.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final LocationTracker _tracker = LocationTracker();
  final _bloodBag = ["How much Units you need", "1", "2", "3", "4"];
  String _currentSelectedValue = 'How much Units you need';
  String? blood_type;
  late String address;
  late double latitude;
  late double longitude;
  var nameController = TextEditingController();
  var numberController = TextEditingController();

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
    _connection();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Make a Request',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Palette.newText
                      : Palette.darkText,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                          floatingLabelStyle: TextStyle(color: Palette.violet),
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
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image.asset(
                              'images/bangladesh.png',
                              height: 16,
                              width: 16,
                            ),
                          ),
                          hintText: 'Enter your Phone Number',
                          label: const Text('Phone'),
                          border: const OutlineInputBorder(),
                          floatingLabelStyle:
                              const TextStyle(color: Palette.violet),
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
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(10),
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _currentSelectedValue = newValue!;
                                  });
                                },
                                items: _bloodBag.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.newText
                                            : Palette.card,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
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
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.newText
                                  : Palette.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: SelectBlood(
                          blood_type: (String value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            blood_type = value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (_currentSelectedValue !=
                              'How much Units you need') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestValidation(
                                    bag: int.parse(_currentSelectedValue),
                                    initBag: 0,
                                    blood_type: blood_type ?? "AB+",
                                    latitude: latitude,
                                    longitude: longitude,
                                    name: nameController.text,
                                    number: (numberController.text.length == 11)
                                        ? ('+88${numberController.text}')
                                        : (numberController.text.length == 13)
                                            ? ('+${numberController.text}')
                                            : numberController.text,
                                    address: address),
                              ),
                            );
                          }
                        }
                      },
                      child: Center(
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
                            child: Text(
                              'Request',
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
      ),
    );
  }
}
