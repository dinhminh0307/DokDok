import 'package:dokdok/src/docker_image/domain/entities/docker_image_model.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';

class DockerImageUsecase {
  final DockerImageInterface _repository;
  DockerImageUsecase(this._repository);

  Future<List<DockerImageModel>> getDockerImages() async {
    return await _repository.getDockerImages();
  }
}