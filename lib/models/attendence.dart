// To parse this JSON data, do
//
//     final attendence = attendenceFromJson(jsonString);

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Attendence attendenceFromJson(String str) => Attendence.fromJson(json.decode(str));

String attendenceToJson(Attendence data) => json.encode(data.toJson());

class Attendence {
    Attendence({
        @required this.id,
        @required this.userId,
        @required this.attendAt,
        @required this.exactLocation,
    });

    final int? id;
    final int? userId;
    final DateTime? attendAt;
    final String? exactLocation;

    factory Attendence.fromJson(Map<String, dynamic> json) => Attendence(
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        attendAt: json["attendAt"] == null ? null : DateTime.parse(json["attendAt"]),
        exactLocation: json["exactLocation"] == null ? null : json["exactLocation"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "userId": userId == null ? null : userId,
        "attendAt": attendAt == null ? null : attendAt!.toIso8601String(),
        "exactLocation": exactLocation == null ? null : exactLocation,
    };
}
