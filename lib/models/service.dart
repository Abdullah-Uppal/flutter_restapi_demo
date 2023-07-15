class Service {
  final int id;
  final String title;
  final String description;
  final String status;

  Service(
      {required this.id,
      required this.title,
      required this.description,
      required this.status});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: int.parse(json['id']),
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
}
