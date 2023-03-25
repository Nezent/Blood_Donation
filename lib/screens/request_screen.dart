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
    return Scaffold(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Make a Request',
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
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
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
                                      style: const TextStyle(
                                        color: Palette.outText,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: Text(
                        'Blood Type',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.newText,
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
                        if (_formKey.currentState!.validate()) {
                          if (_currentSelectedValue !=
                              'How much Units you need') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RequestValidation(
                                        bag: int.parse(_currentSelectedValue),
                                        blood_type: blood_type ?? "AB+",
                                        latitude: latitude,
                                        longitude: longitude,
                                        name: nameController.text,
                                        number: numberController.text,
                                        address: address)));
                          }
                        }
                      },
                      child: Center(
                        child: Container(
                          height: 46,
                          width: 340,
                          decoration: BoxDecoration(
                            color: Palette.cyan,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Request',
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
      ),
    );
  }
}
