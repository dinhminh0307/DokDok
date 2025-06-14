import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';

abstract class DockerImageInterface {
  List<DockerImageModel> getDockerImages();
}