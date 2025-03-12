import 'package:flutter/material.dart';

class Notify {
  DateTime? date;
  TimeOfDay? time;
  String? title;
  String? description;

  Notify({this.date, this.time, this.title, this.description});

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'title': title,
      'description': description,
    };
  }

  factory Notify.fromJson(Map<String, dynamic> json) {
    List<String>? timeParts = json['time']?.split(':');
    return Notify(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: timeParts != null ? TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])) : null,
      title: json['title'],
      description: json['description'],
    );
  }
}
