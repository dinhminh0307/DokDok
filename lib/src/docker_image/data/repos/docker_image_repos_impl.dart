import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';

class DockerImageInterfaceImpl extends DockerImageInterface{
  @override
  List<DockerImageModel> getDockerImages() {
    // TODO: implement getDockerImages
    final List<DockerImageModel> dockerImages = [
    DockerImageModel(
      name: 'nginx',
      tag: 'latest',
      size: '133 MB',
      created: '2 days ago',
    ),
    DockerImageModel(
      name: 'ubuntu',
      tag: '20.04',
      size: '29.9 MB',
      created: '1 week ago',
    ),
    DockerImageModel(
      name: 'node',
      tag: '14-alpine',
      size: '73.5 MB',
      created: '3 days ago',
    ),
  ];
    return dockerImages;
  }

}