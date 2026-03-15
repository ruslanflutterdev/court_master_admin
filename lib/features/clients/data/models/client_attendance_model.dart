import '../../../schedule/data/models/schedule_event_model.dart';

class ClientAttendanceModel {
  final String id;
  final int status;
  final ScheduleEventModel event;

  ClientAttendanceModel({
    required this.id,
    required this.status,
    required this.event,
  });

  factory ClientAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ClientAttendanceModel(
      id: json['id'],
      status: json['status'],
      event: ScheduleEventModel.fromJson(json['event']),
    );
  }
}
