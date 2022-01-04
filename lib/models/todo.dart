// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  Todo({
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
    required this.id,
    required this.v,
  });

  String title;
  String description;
  DateTime deadline;
  bool isCompleted;
  String id;
  int v;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        description: json["description"],
        deadline: DateTime.parse(json["deadline"]),
        isCompleted: json["isCompleted"],
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "deadline": deadline.toIso8601String(),
        "isCompleted": isCompleted,
        "_id": id,
        "__v": v,
      };
}