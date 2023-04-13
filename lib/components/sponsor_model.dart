import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

SponsorModel sponsorModelFromJson(String str) =>
    SponsorModel.fromJson(json.decode(str));

String sponsorModelToJson(SponsorModel data) => json.encode(data.toJson());

class SponsorModel {
  SponsorModel({
    required this.id,
    required this.picture,
    required this.name,
  });

  ObjectId? id;
  String picture;
  String name;

  factory SponsorModel.fromJson(Map<String, dynamic> json) => SponsorModel(
        id: json["_id"],
        picture: json["picture"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "picture": picture,
        "name": name,
      };
}
