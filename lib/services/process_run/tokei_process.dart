import 'dart:convert';

import 'package:dokdok/services/process_run/process.dart';
import 'dart:io';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/stdio.dart';

class TokeiProcess implements Process {
 @override
  Future<bool> isInstalled() async {
    var cmd = ProcessCmd('tokei', ['--version']);
    var res = await runCmd(cmd);
    print('Tokei check exitCode: ${res.exitCode}');
    print('Tokei check stdout: ${res.stdout}');
    print('Tokei check stderr: ${res.stderr}');
    if (res.exitCode == 0) {
      print('Tokei is installed: ${res.stdout}');
      return true;
    } else {
      print('Tokei not found: ${cmd.toString()}');
      return false;
    }
  }
  @override
  Future<String> runCommand(var cmd) async {
    var res = await runCmd(cmd);
    if (res.exitCode == 0) {
      return res.stdout.toString();
    } else {
      print('Error running command: ${cmd.toString()}');
      print('Exit code: ${res.exitCode}');
      print('Error: ${res.stderr}');
      return '';
    }
  }

  Future<bool> installTokei() async {
    // This example uses Chocolatey for Windows. Adjust for your OS as needed.
    var cmd = ProcessCmd('winget ', ['install', 'XAMPPRocky.tokei', '--accept-source-agreements', '--accept-package-agreements']);
    var res = await runCmd(cmd, verbose: true);
    if (res.exitCode == 0) {
      print('Tokei installation started: ${res.stdout}');
      return true;
    } else {
      print('Failed to start Tokei installation: ${res.stderr}');
      return false;
    }
  }

  Future<String?> getMainLanguage(String folderPath) async {
    var cmd = ProcessCmd('tokei', [folderPath, '--output', 'json']);
    var res = await runCmd(cmd, stdout: stdout);
    if (res.exitCode != 0) {
      print('Error running Tokei: ${res.stderr}');
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
      print('Failed to parse Tokei output: $e');
      return null;
    }
  }
}