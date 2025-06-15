import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/services/process_run/tokei_process.dart';
import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:get_it/get_it.dart';

class DockerTemplateUseCase {
  final TokeiProcess _tokeiProcess = GetIt.I<TokeiProcess>();

  DockerTemplateUseCase();

  Future<String> getProgrammingLanguages(String folderPath) async {
   final tokeiProcess = GetIt.I<TokeiProcess>();
   final mainLang = await tokeiProcess.getMainLanguage(folderPath);
    return mainLang ?? 'Unknown';
  }

  Future<String> getAvailableLanguages() async {
    final db = GetIt.I<DbManager<Languages>>();
    final languages = await db.getAll();
    return languages.map((lang) => lang.languageName).join(', ');
  }
}