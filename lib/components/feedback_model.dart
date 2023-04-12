import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) =>
    FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
  FeedbackModel({
    required this.number,
    required this.feedback,
  });

  String number;
  String feedback;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        number: json["number"],
        feedback: json["feedback"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "feedback": feedback,
      };
}
