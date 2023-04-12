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
    required this.donated,
    required this.donations,
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
  int donated;
  List<dynamic> donations;

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
        donated: json["donated"],
        donations: List<dynamic>.from(json["donations"].map((x) => x)),
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
        "donated": donated,
        "donations": List<dynamic>.from(donations.map((x) => x)),
      };
}
