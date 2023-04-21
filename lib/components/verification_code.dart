import 'dart:convert';

import 'package:blood_connection/components/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerificationCode {
  static void sendCode(String code, String number) async {
    String message = "Your Blood Connection Vertification Code is $code";
    var response = await http.post(
      Uri.parse(
          'http://bulksmsbd.net/api/smsapi?api_key=TLF3sixpkNeLUATJVzkP&type=text&number=$number&senderid=8809617611040&message=$message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'code': code,
      }),
    );
    if (response.statusCode != 200) {
      final SnackBar snackBar = SnackbarMessage("Verification Error!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
