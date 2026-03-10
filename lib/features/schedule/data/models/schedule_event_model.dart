import 'package:flutter/material.dart';

class ScheduleEventModel {
  final String id;
  final String eventType;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String color;
  final String courtId;
  final String? groupId;
  final String? clientName;
  final String? clientPhone;
  final String? coachId;

  ScheduleEventModel({
    required this.id,
    required this.eventType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.courtId,
    this.groupId,
    this.clientName,
    this.clientPhone,
    this.coachId,
  });

  factory ScheduleEventModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay parseTime(String t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return ScheduleEventModel(
      id: json['id'],
      eventType: json['type'],
      date: DateTime.parse(json['date']),
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      color: json['colorHex'],
      courtId: json['courtId'],
      groupId: json['groupId'],
      clientName: json['clientName'],
      clientPhone: json['clientPhone'],
      coachId: json['coachId'],
    );
  }
}
