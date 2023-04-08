import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:blood_connection/components/components.dart';

class MongoDB {
  StreamController requestController = StreamController();
  StreamController donorController = StreamController();
  StreamController profileController = StreamController();
  StreamController donorListController = StreamController();

  static var dataBase;
  static connect() async {
    try {
      dataBase = await Db.create(
              "mongodb+srv://Anon:2010013@cluster0.seaspb1.mongodb.net/Blood_Connection?retryWrites=true&w=majority")
          .timeout(
        const Duration(seconds: 10),
      );
      await dataBase.open(secure: true);
      // inspect(db);
    } on SocketException {
      final SnackBar snackBar = SnackbarMessage("No Internet Connection!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    } on TimeoutException {
      return;
    } on ConnectionException {
      final SnackBar snackBar =
          SnackbarMessage("Network Failure: IO Exception!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    } on ClientException {
      final SnackBar snackBar = SnackbarMessage("CAN'T FIND CLIENT!");
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
  // Request Model

  static Future<void> insert(RequestModel data) async {
    try {
      await dataBase.collection('Request').insertOne(data.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> getData() async {
    try {
      final arrData = await dataBase.collection('Request').find().toList();
      requestController.sink.add(arrData);
    } on NoSuchMethodError {
      return;
    } on MongoDartError {
      return;
    } on ConnectionException {
      return;
    }
  }

  // Register Model

  static Future<void> register(RegisterModel data) async {
    try {
      await dataBase.collection('Register').insertOne(data.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> getUser(String bloodType) async {
    try {
      final arrData = await dataBase
          .collection('Register')
          .find({"isAvailable": true, "blood_type": bloodType}).toList();
      donorController.sink.add(arrData);
    } on NoSuchMethodError {
      return;
    } on MongoDartError {
      return;
    } on ConnectionException {
      return;
    }
  }

  Future<void> getDonorList(String bloodType, String address) async {
    try {
      final arrData = await dataBase.collection('Register').find({
        "isAvailable": true,
        "blood_type": bloodType,
        "address": address,
      }).toList();
      donorListController.sink.add(arrData);
    } on NoSuchMethodError {
      return;
    } on MongoDartError {
      return;
    } on ConnectionException {
      return;
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
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserData(ObjectId? id) async {
    try {
      final userData =
          await dataBase.collection('Register').findOne({"_id": id});
      return userData;
    } catch (e) {
      return null;
    }
  }

  Future<void> getProfileData(ObjectId? id) async {
    try {
      final userProfile =
          await dataBase.collection('Register').findOne({"_id": id});
      profileController.sink.add(userProfile);
    } catch (e) {
      return;
    }
  }

  static Future<Map<String, dynamic>?> getRequestData(ObjectId? id) async {
    try {
      final userRequest =
          await dataBase.collection('Request').findOne({"_id": id});
      return userRequest;
    } catch (e) {
      return null;
    }
  }

  static Future<void> changeAvailability(ObjectId? id, bool value) async {
    try {
      await dataBase
          .collection('Register')
          .updateOne({"_id": id}, modify.set("isAvailable", value));
    } catch (e) {
      return;
    }
  }

  static Future<void> addBloodUnits(ObjectId? id, int value) async {
    try {
      await dataBase
          .collection('Request')
          .updateOne({"_id": id}, modify.set("initBag", value));
    } catch (e) {
      return;
    }
  }

  static Future<void> deleteUnitRequest(ObjectId? id) async {
    try {
      await dataBase
          .collection('Register')
          .updateOne({"_id": id}, modify.set("donations", []));
    } catch (e) {
      return;
    }
  }

  static Future<void> deleteRequest(ObjectId? id) async {
    try {
      await dataBase.collection('Request').deleteOne({"_id": id});
    } catch (e) {
      return;
    }
  }

  static Future<void> addDonations(ObjectId? id, ObjectId requestId) async {
    try {
      await dataBase.collection('Register').updateOne(
        {"_id": id},
        modify.addToSet('donations', requestId),
      );
    } catch (e) {
      return;
    }
  }

  static Future<void> changeProfilePicture(ObjectId? id, String value) async {
    try {
      await dataBase.collection('Register').updateOne(
        {"_id": id},
        modify.set("profilePicture", value),
      );
    } catch (e) {
      return;
    }
  }
}
