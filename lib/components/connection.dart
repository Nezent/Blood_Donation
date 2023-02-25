import 'dart:developer';

import 'package:blood_connection/components/request_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(
        "mongodb+srv://Anon:2010013@cluster0.seaspb1.mongodb.net/Blood_Connection?retryWrites=true&w=majority");
    await db.open();
    userCollection = db.collection('Request');
    inspect(db);
  }

  static Future<String> insert(RequestModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        print("Data Inserted");
        return "Data Inserted";
      } else {
        print("Sorry");
        return "Something Wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }
}
