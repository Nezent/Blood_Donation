import 'package:blood_connection/components/connection.dart';
import 'package:blood_connection/components/register_model.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../widgets/palette.dart';

class ValidationScreen extends StatefulWidget {
  String name, number, password, gender, blood_type, address;
  double latitude, longitude;
  ValidationScreen(
      {super.key,
      required this.address,
      required this.blood_type,
      required this.gender,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.number,
      required this.password});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
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
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/pin.png",
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "OTP Varification",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Palette.cyanText),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 300,
                child: Center(
                  child: Text(
                    "Welcome ${widget.name}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.cyanText),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Center(
                  child: Text(
                    "OTP sent to ${widget.number.replaceRange(3, 9, '******')}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.textColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              OtpTextField(
                fieldWidth: 64,
                numberOfFields: 4,
                enabledBorderColor: Palette.cyan,
                keyboardType: TextInputType.number,
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.cyanText),
                borderColor: const Color(0xFF512DA8),
                showFieldAsBox: true,
                onSubmit: (String verificationCode) async {
                  if (verificationCode == "6161") {
                    await _insertData(
                      widget.name,
                      widget.number,
                      widget.password,
                      widget.blood_type,
                      widget.gender,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AfterDonation(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 300,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't get the code?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Palette.textColor),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        "Resend",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Palette.cyanText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      address: widget.address,
      latitude: widget.latitude,
      longitude: widget.longitude,
      isAvailable: true,
    );
    await MongoDB.register(data);
  }
}
