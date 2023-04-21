// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/forget_validation.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isReseting = false;
  final forgetKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
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
      body: SafeArea(
        child: Form(
          key: forgetKey,
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                    floatingLabelStyle: TextStyle(color: Palette.violet),
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
              const SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isReseting = true;
                    });
                    if (forgetKey.currentState!.validate()) {
                      _checkUser(
                        (numberController.text.length == 11)
                            ? ('+88${numberController.text}')
                            : (numberController.text.length == 13)
                                ? ('+88${numberController.text}')
                                : numberController.text,
                      );
                    }

                    setState(() {
                      isReseting = false;
                    });
                  },
                  child: Container(
                    height: 46,
                    width: 340,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyan
                          : Palette.darkSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: isReseting
                          ? const JumpingDots(
                              radius: 8,
                              color: Palette.card,
                              animationDuration: Duration(milliseconds: 200),
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
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkUser(String number) async {
    try {
      var userData = await MongoDB.checkUserData(number);
      if (userData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetValidation(
              number: (numberController.text.length == 11)
                  ? ('+88${numberController.text}')
                  : (numberController.text.length == 13)
                      ? ('+88${numberController.text}')
                      : numberController.text,
            ),
          ),
        );
      } else {
        final SnackBar snackBar = SnackbarMessage("CAN'T FIND USER!");
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("CAN'T FIND USER!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
