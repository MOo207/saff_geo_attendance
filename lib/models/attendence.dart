// To parse this JSON data, do
//
//     final attendence = attendenceFromJson(jsonString);

import 'dart:convert';

Attendence attendenceFromJson(String str) =>
    Attendence.fromJson(json.decode(str));

String attendenceToJson(Attendence data) => json.encode(data.toJson());

class Attendence {
  Attendence({
    required this.user,
    required this.attendAt,
  });

  final int? user;
  final DateTime? attendAt;

  factory Attendence.fromJson(Map<String, dynamic> json) => Attendence(
        user: json["user"] ?? null,
        attendAt:
            json["attendAt"] == null ? null : DateTime.parse(json["attendAt"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user ?? null,
        "attendAt": attendAt == null ? null : attendAt!.toIso8601String(),
      };
}
