// To parse this JSON data, do
//
//     final subjects = subjectsFromJson(jsonString);

import 'dart:convert';

Subjects subjectsFromJson(String str) => Subjects.fromJson(json.decode(str));

String subjectsToJson(Subjects data) => json.encode(data.toJson());

class Subjects {
  List<Result> result;
  bool status;

  Subjects({
    required this.result,
    required this.status,
  });

  factory Subjects.fromJson(Map<String, dynamic> json) => Subjects(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String title;
  String courseCode;
  List<String> department;
  int totalSeat;
  int availableSeat;
  Result({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.title,
    required this.courseCode,
    required this.department,
    required this.totalSeat,
    required this.availableSeat
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["ID"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        deletedAt: json["DeletedAt"],
        title: json["title"],
        courseCode: json["course_code"],
        availableSeat: json['available_seat'],
        department: List<String>.from(json["department"].map((x) => x)),
        totalSeat: json["total_seat"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "DeletedAt": deletedAt,
        "title": title,
        "available_seat":availableSeat,
        "course_code": courseCode,
        "department": List<dynamic>.from(department.map((x) => x)),
        "total_seat": totalSeat,
      };
}
