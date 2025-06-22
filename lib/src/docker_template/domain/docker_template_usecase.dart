import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/services/db/templates.dart';
import 'package:dokdok/services/log/console.dart';
import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/services/process_run/create_file.dart';
import 'package:dokdok/services/process_run/tokei_process.dart';
import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:dokdok/src/docker_template/data/templates.dart';
import 'package:get_it/get_it.dart';

class DockerTemplateUseCase {
  final ConsoleLog _consoleLog;
  final TokeiProcess _tokeiProcess;
  final TemplatesDbManager _templatesDb;
  final CreateFileProcess _createFileProcess;
  late final DbManager<Languages> db;

  DockerTemplateUseCase({
    required TokeiProcess tokeiProcess,
    required Log log,
    required DbManager<Languages> languagesDb,
    required TemplatesDbManager templatesDb,
    required CreateFileProcess createFileProcess,
  }) : _consoleLog = log as ConsoleLog,
       _tokeiProcess = tokeiProcess,
       _templatesDb = templatesDb,
       db = languagesDb,
       _createFileProcess = createFileProcess;

  Future<String> getProgrammingLanguages(String folderPath) async {
   final tokeiProcess = GetIt.I<TokeiProcess>();
   final mainLang = await tokeiProcess.getMainLanguage(folderPath);
    return mainLang ?? 'Unknown';
  }

  Future<List<Languages>> getAvailableLanguages() async {
    final db = GetIt.I<DbManager<Languages>>();
    final languages = await db.getAll();
    return languages;
  }

  Future<String> getDockerfileTemplate(int language) async {
    final db = GetIt.I<TemplatesDbManager>();
    final template = await db.getByProgramId(language);
    if (template == null) {
      throw Exception('Template not found for program ID: $language');
    }
    return template.code ?? 'No template available for this language.';
  }

  Future<void> createDockerfile(String folderPath, String content, {String fileName = "Dockerfile"}) async {
    final createFileProcess = GetIt.I<CreateFileProcess>();
    var res = await createFileProcess.createFile(folderPath, fileName, content: content);

    if(res.existsSync()) {
      _consoleLog.info('Dockerfile created successfully at: ${res.path}');
    } else {
      _consoleLog.error('Failed to create Dockerfile.');
    }
  }
}