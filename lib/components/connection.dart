import 'dart:async';
import 'dart:developer';

import 'package:blood_connection/components/register_model.dart';
import 'package:blood_connection/components/request_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  StreamController requestController = StreamController();
  StreamController donorController = StreamController();
  static var db;
  static connect() async {
    db = await Db.create(
        "mongodb+srv://Anon:2010013@cluster0.seaspb1.mongodb.net/Blood_Connection?retryWrites=true&w=majority");
    await db.open();
    inspect(db);
  }

  // Request Model

  static Future<String> insert(RequestModel data) async {
    try {
      var result = await db.collection('Request').insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> getData() async {
    final arrData = await db.collection('Request').find().toList();
    requestController.sink.add(arrData);
  }

  // Register Model

  static Future<String> register(RegisterModel data) async {
    try {
      var result = await db.collection('Register').insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> getUser() async {
    final arrData =
        await db.collection('Register').find({"isAvailable": true}).toList();
    donorController.sink.add(arrData);
  }

  static Future<Map<String, dynamic>?> logIn(
      String number, String password) async {
    try {
      final data = await db
          .collection('Register')
          .findOne({"number": number, "password": password});
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserData(ObjectId? id) async {
    try {
      final userData = await db.collection('Register').findOne({"_id": id});
      return userData;
    } catch (e) {
      return null;
    }
  }

  static Future<void> changeAvailability(ObjectId? id, bool value) async {
    try {
      await db
          .collection('Register')
          .updateOne({"_id": id}, modify.set("isAvailable", value));
    } catch (e) {
      return;
    }
  }
}
