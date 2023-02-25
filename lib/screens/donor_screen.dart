import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final _bloodType = ["AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"];
  String _currentSelectedValue = 'AB+';
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                child: Text(
                  'Blood Donors',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.outText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 17, 8),
                child: Container(
                  height: 24,
                  width: 62,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Palette.outText,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Palette.outText,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return DonorList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
