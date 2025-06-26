class Containers {
  final String id;
  final String name;
  final String image;
  final String status;
  final String createdAt;
  final String port;

  Containers({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.port,
  });

  factory Containers.fromJson(Map<String, dynamic> json) {
    return Containers(
      id: json['ID'] ?? '',
      name: json['Names'] ?? '',
      image: json['Image'] ?? '',
      status: json['Status'] ?? ''  ,
      createdAt: json['CreatedAt'] ?? ''  ,
      port: json['Ports'] ?? '',
    );
  }
}