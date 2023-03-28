import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
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
    required this.isDark,
  });

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
  bool isDark;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
        isDark: json["isDark"],
      );

  Map<String, dynamic> toJson() => {
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
        "isDark": isDark,
      };
}
