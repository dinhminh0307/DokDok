import 'package:dokdok/services/process_run/tokei_process.dart';
import 'package:get_it/get_it.dart';

class DockerTemplateUseCase {
  final TokeiProcess _tokeiProcess = GetIt.I<TokeiProcess>();

  DockerTemplateUseCase();

  Future<String> getProgrammingLanguages(String folderPath) async {
   final tokeiProcess = GetIt.I<TokeiProcess>();
   final mainLang = await tokeiProcess.getMainLanguage(folderPath);
   print('Main language: $mainLang');
    return mainLang ?? 'Unknown';
  }
}