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
    required this.address,
  });

  String name;
  String bloodType;
  String number;
  int bag;
  String address;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        name: json["name"],
        bloodType: json["blood_type"],
        number: json["number"],
        bag: json["bag"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "blood_type": bloodType,
        "number": number,
        "bag": bag,
        "address": address,
      };
}
