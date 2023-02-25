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
  });

  String name;
  String bloodType;
  String number;
  int bag;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        name: json["name"],
        bloodType: json["blood_type"],
        number: json["number"],
        bag: json["bag"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "blood_type": bloodType,
        "number": number,
        "bag": bag,
      };
}
