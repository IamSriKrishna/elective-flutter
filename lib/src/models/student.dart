// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  Data data;
  String message;
  bool status;

  Student({
    required this.data,
    required this.message,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  String department;
  int id;
  String name;
  String subject;
  int registerNo;

  Data({
    required this.department,
    required this.id,
    required this.name,
    required this.subject,
    required this.registerNo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        department: json["department"],
        id: json["id"],
        subject: json['subject'] ?? "",
        name: json["name"],
        registerNo: json["register_no"],
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "id": id,
        "name": name,
        "subject": subject,
        "register_no": registerNo,
      };
}
