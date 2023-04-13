// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  final String number;
  const ChangePassword({super.key, required this.number});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var passwordController = TextEditingController();
  var passwordCheckController = TextEditingController();
  final changePassword = GlobalKey<FormState>();
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: changePassword,
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
                  obscureText: false,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: Palette.violet),
                    hintText: 'Enter New Password',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value != passwordController.text) {
                      return "Password Didn't Match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  controller: passwordCheckController,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: Palette.violet),
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
              const SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isLogin = true;
                    });
                    if (changePassword.currentState!.validate()) {
                      _changePassword(
                          widget.number, passwordCheckController.text);
                      SharedPreferences session =
                          await SharedPreferences.getInstance();
                      await session.remove('objectId');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    }

                    setState(() {
                      isLogin = false;
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
                      child: isLogin
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

  _changePassword(String number, String password) async {
    await MongoDB.forgetPassword(number, password);
  }
}
