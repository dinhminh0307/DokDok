import 'dart:convert';

import 'package:dokdok/services/process_run/interface.dart';
import 'dart:io';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/stdio.dart';

class TokeiProcess extends BaseProcess implements InstallableProcess {
  TokeiProcess(super.logger);


 @override
  Future<bool> isInstalled() async {
    var res = await runCommand('tokei', ['--version']);
    if (res.exitCode == 0) {
      logger.info('Tokei is installed: ${res.stdout}');
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getMainLanguage(String folderPath) async {

    var res = await runCommand('tokei', [folderPath, '--output', 'json']);
    if (res.exitCode != 0) {
      logger.error('Error running Tokei: ${res.stderr}');
      return null;
    }
    try {
      final jsonResult = json.decode(res.stdout.toString()) as Map<String, dynamic>;
      String? mainLang;
      int maxCode = 0;
      for (final entry in jsonResult.entries) {
        final lang = entry.key;
        if (lang == 'Total' || lang == 'JSON') continue;
        final stats = entry.value as Map<String, dynamic>;
        final code = stats['code'] as int? ?? 0;
        if (code > maxCode) {
          maxCode = code;
          mainLang = lang;
        }
      }
      return mainLang;
    } catch (e) {
      logger.error('Failed to parse Tokei output: $e');
      return null;
    }
  }

  
  @override
  Future<bool> install() async {
    var res = await runCommand('winget ', ['install', 'XAMPPRocky.tokei', '--accept-source-agreements', '--accept-package-agreements']);
    if (res.exitCode == 0) {
      logger.info('Tokei installation started: ${res.stdout}');
      return true;
    } else {
      logger.error('Failed to start Tokei installation: ${res.stderr}');
      return false;
    }
  }
}