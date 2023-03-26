import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/request_model.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class RequestValidation extends StatefulWidget {
  String name, number, blood_type, address;
  int bag;
  double latitude, longitude;
  RequestValidation(
      {super.key,
      required this.bag,
      required this.blood_type,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.number,
      required this.address});

  @override
  State<RequestValidation> createState() => _RequestValidationState();
}

class _RequestValidationState extends State<RequestValidation> {
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
                  if (verificationCode == "1616") {
                    await _insertData(
                      widget.name,
                      widget.number,
                      widget.bag,
                      widget.blood_type,
                      widget.latitude,
                      widget.longitude,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AfterRequest(),
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

  Future<void> _insertData(String name, String number, int bag,
      String blood_type, double latitude, double longitude) async {
    final data = RequestModel(
      name: name,
      bloodType: blood_type,
      number: number,
      bag: bag,
      address: widget.address,
      latitude: latitude,
      longitude: longitude,
    );
    var result = await MongoDB.insert(data);
  }
}
