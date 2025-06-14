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

  /// Parse a line from `docker images --format "{{.Repository}} {{.Tag}} {{.Size}} {{.CreatedSince}}"`
  /// Example line: "nginx latest 133MB 2 days ago"
  static DockerImageModel? fromCliLine(String line) {
    // Split by space, but keep the last two fields (size and created) together
    final parts = line.trim().split(RegExp(r'\s+'));
    if (parts.length < 4) return null;

    // Name and tag are always the first two, size is third, created is the rest
    final name = parts[0];
    final tag = parts[1];
    final size = parts[2];
    final created = parts.sublist(3).join(' ');

    return DockerImageModel(
      name: name,
      tag: tag,
      size: size,
      created: created,
    );
  }

  /// Parse multiple lines
  static List<DockerImageModel> listFromCliOutput(String output) {
    return output
        .split('\n')
        .map((line) => DockerImageModel.fromCliLine(line))
        .whereType<DockerImageModel>()
        .toList();
  }
}