import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

RegisterDataModel registerDataModelFromJson(String str) =>
    RegisterDataModel.fromJson(json.decode(str));

String registerDataModelToJson(RegisterDataModel data) =>
    json.encode(data.toJson());

class RegisterDataModel {
  RegisterDataModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.bloodType,
    required this.gender,
    required this.number,
    required this.password,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.donated,
    required this.donations,
  });

  ObjectId? id;
  String name;
  String? profilePicture;
  String bloodType;
  String gender;
  String number;
  String password;
  String address;
  double latitude;
  double longitude;
  bool isAvailable;
  int donated;
  List<dynamic> donations;

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) =>
      RegisterDataModel(
        id: json["_id"],
        name: json["name"],
        profilePicture: json["profilePicture"],
        bloodType: json["blood_type"],
        gender: json["gender"],
        number: json["number"],
        password: json["password"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isAvailable: json["isAvailable"],
        donated: json["donated"],
        donations: List<dynamic>.from(json["donations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePicture": profilePicture,
        "blood_type": bloodType,
        "gender": gender,
        "number": number,
        "password": password,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "isAvailable": isAvailable,
        "donated": donated,
        "donations": List<dynamic>.from(donations.map((x) => x)),
      };
}
