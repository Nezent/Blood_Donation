import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

RequestDataModel requestDataModelFromJson(String str) =>
    RequestDataModel.fromJson(json.decode(str));

String requestDataModelToJson(RequestDataModel data) =>
    json.encode(data.toJson());

class RequestDataModel {
  RequestDataModel({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.number,
    required this.bag,
    required this.initBag,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  ObjectId? id;
  String name;
  String bloodType;
  String number;
  int bag;
  int initBag;
  String address;
  double latitude;
  double longitude;

  factory RequestDataModel.fromJson(Map<String, dynamic> json) =>
      RequestDataModel(
        id: json["_id"],
        name: json["name"],
        bloodType: json["blood_type"],
        number: json["number"],
        bag: json["bag"],
        initBag: json["initBag"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "blood_type": bloodType,
        "number": number,
        "bag": bag,
        "initBag": initBag,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
