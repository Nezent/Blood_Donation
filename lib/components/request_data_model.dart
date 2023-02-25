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
  });

  ObjectId? id;
  String name;
  String bloodType;
  String number;
  int bag;

  factory RequestDataModel.fromJson(Map<String, dynamic> json) =>
      RequestDataModel(
        id: json["id"],
        name: json["name"],
        bloodType: json["blood_type"],
        number: json["number"],
        bag: json["bag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "blood_type": bloodType,
        "number": number,
        "bag": bag,
      };
}
