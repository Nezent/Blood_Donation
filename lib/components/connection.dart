import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:blood_connection/components/register_model.dart';
import 'package:blood_connection/components/request_model.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:blood_connection/components/components.dart';

class MongoDB {
  StreamController requestController = StreamController();
  StreamController donorController = StreamController();
  static var dataBase;
  static connect() async {
    try {
      dataBase = await Db.create(
              "mongodb+srv://Anon:2010013@cluster0.seaspb1.mongodb.net/Blood_Connection?retryWrites=true&w=majority")
          .timeout(
        const Duration(seconds: 3),
      );
      await dataBase.open();
      // inspect(db);
    } on SocketException {
      final SnackBar snackBar = SnackbarMessage("No Internet Connection!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    } on TimeoutException {
      final SnackBar snackBar = SnackbarMessage("Database Timeout!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("IO Exception!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  // Request Model

  static Future<void> insert(RequestModel data) async {
    try {
      await dataBase.collection('Request').insertOne(data.toJson());
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("Request Was Unsuccessful!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> getData() async {
    try {
      final arrData = await dataBase.collection('Request').find().toList();
      requestController.sink.add(arrData);
    } on NoSuchMethodError {
      final SnackBar snackBar = SnackbarMessage("Cant't Load Data!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  // Register Model

  static Future<void> register(RegisterModel data) async {
    try {
      await dataBase.collection('Register').insertOne(data.toJson());
    } catch (e) {
      final SnackBar snackBar =
          SnackbarMessage("Registration Was Unsuccessful!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> getUser() async {
    try {
      final arrData = await dataBase
          .collection('Register')
          .find({"isAvailable": true}).toList();
      donorController.sink.add(arrData);
    } on NoSuchMethodError {
      final SnackBar snackBar = SnackbarMessage("Cant't Load Data!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  static Future<Map<String, dynamic>?> logIn(
      String number, String password) async {
    try {
      final data = await dataBase
          .collection('Register')
          .findOne({"number": number, "password": password});
      return data;
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("Cant't Login Right Now!");
      snackbarKey.currentState?.showSnackBar(snackBar);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserData(ObjectId? id) async {
    try {
      final userData =
          await dataBase.collection('Register').findOne({"_id": id});
      return userData;
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("User Data Not Found!");
      snackbarKey.currentState?.showSnackBar(snackBar);
      return null;
    }
  }

  static Future<void> changeAvailability(ObjectId? id, bool value) async {
    try {
      await dataBase
          .collection('Register')
          .updateOne({"_id": id}, modify.set("isAvailable", value));
    } catch (e) {
      final SnackBar snackBar = SnackbarMessage("Try Again After Sometime!");
      snackbarKey.currentState?.showSnackBar(snackBar);
      return;
    }
  }
}
