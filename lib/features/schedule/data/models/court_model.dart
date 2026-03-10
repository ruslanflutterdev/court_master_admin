class CourtModel {
  final String id;
  final String name;

  CourtModel({required this.id, required this.name});

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(id: json['id'], name: json['name']);
  }
}
