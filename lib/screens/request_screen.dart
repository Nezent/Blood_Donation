import 'package:blood_connection/components/location_tracker.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/request_model.dart';
import 'package:blood_connection/widgets/widgets.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  LocationTracker _tracker = LocationTracker();
  final _bloodType = ["How much Units you need", "1", "2", "3", "4"];
  String _currentSelectedValue = 'How much Units you need';
  String? blood_type;
  late String address;
  var nameController = TextEditingController();
  var numberController = TextEditingController();

  void _getAddress() async {
    List temporary_address = await _tracker.requestScreenAddress();
    var temp_address = temporary_address.elementAt(0).split(' ');
    var short_address = temp_address[0].trim();
    address = "${short_address},${temporary_address.elementAt(1)}";
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                              items: _bloodType.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SelectBlood(
                      blood_type: (String value) {
                        blood_type = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _insertData(
                          nameController.text,
                          numberController.text,
                          int.parse(_currentSelectedValue),
                          blood_type!);
                    },
                    child: Center(
                      child: Container(
                        height: 46,
                        width: 340,
                        decoration: BoxDecoration(
                          color: Palette.cardBackground,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Text(
                            'Request',
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
      ),
    );
  }

  Future<void> _insertData(
      String name, String number, int bag, String blood_type) async {
    final data = RequestModel(
      name: name,
      bloodType: blood_type,
      number: number,
      bag: bag,
      address: address,
    );
    var result = await MongoDB.insert(data);
    _clearData();
  }

  void _clearData() {
    nameController.text = '';
    numberController.text = '';
    _currentSelectedValue = 'How much Units you need';
  }
}
