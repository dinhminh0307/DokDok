class DockerImageModel {
  final String name;
  final String tag;
  final String size;
  final String created;

  DockerImageModel({
    required this.name,
    required this.tag,
    required this.size,
    required this.created,
  });
}
