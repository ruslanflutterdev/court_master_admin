import 'package:flutter/material.dart';

class ScheduleEventModel {
  final String id;
  final String eventType;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String color;
  final String courtId;
  final String? courtName;
  final String? groupId;
  final String? groupName;
  final String? clientName;
  final String? clientPhone;
  final String? coachId;
  final String? coachFullName;

  ScheduleEventModel({
    required this.id,
    required this.eventType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.courtId,
    this.courtName,
    this.groupId,
    this.groupName,
    this.clientName,
    this.clientPhone,
    this.coachId,
    this.coachFullName,
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
      color: json['colorHex'] ?? '#2196F3',
      courtId: json['courtId'],
      courtName: json['court']?['name'],
      groupId: json['groupId'],
      groupName: json['group']?['name'],
      clientName: json['clientName'],
      clientPhone: json['clientPhone'],
      coachId: json['coachId'],
      coachFullName: json['coach'] != null
          ? '${json['coach']['firstName']} ${json['coach']['lastName']}'
          : null,
    );
  }
}
