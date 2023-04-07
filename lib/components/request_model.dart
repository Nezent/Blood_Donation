import 'dart:convert';

RequestModel requestModelFromJson(String str) =>
    RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    required this.name,
    required this.bloodType,
    required this.number,
    required this.bag,
    required this.initBag,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String name;
  String bloodType;
  String number;
  int bag;
  int initBag;
  String address;
  double latitude;
  double longitude;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
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
