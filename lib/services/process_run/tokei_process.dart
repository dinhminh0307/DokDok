import 'dart:convert';

import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/services/process_run/common/base_installable_process_new.dart';
import 'package:dokdok/utils/platform_utils.dart';
import 'package:dokdok/services/process_run/interfaces/command_interfaces.dart';

/// Language analyzer process that uses Tokei for analyzing code repositories
class TokeiProcess extends BaseInstallableProcess {
  /// Creates a new instance of the Tokei process handler
  /// Automatically detects the platform type for cross-platform support
  TokeiProcess({
    required Log log, 
    ProcessRunner? processRunner,
    PlatformType? platformType
  }) : super(
    log: log, 
    processName: 'Tokei', 
    processRunner: processRunner,
    platformType: platformType
  ) {
    logger.info('Initialized TokeiProcess for platform: ${PlatformUtils.getPlatformName()}');
  }
  
  @override
  String get versionCheckCommand => 'tokei';
  
  @override
  String get installCommand {
    switch (platformType) {
      case PlatformType.windows:
        return 'winget';
      case PlatformType.linux:
        return 'apt-get';
      case PlatformType.macOS:
        return 'brew';
      case PlatformType.other:
        return 'echo';
    }
  }
  
  @override
  List<String> get installArgs {
    switch (platformType) {
      case PlatformType.windows:
        return [
          'install', 
          'XAMPPRocky.tokei', 
          '--accept-source-agreements', 
          '--accept-package-agreements'
        ];
      case PlatformType.linux:
        return ['install', '-y', 'tokei'];
      case PlatformType.macOS:
        return ['install', 'tokei'];
      case PlatformType.other:
        logger.error('Unsupported platform for automatic installation');
        return ['Tokei installation not supported on this platform. Please install manually.'];
    }
  }
    /// Analyzes a folder to determine the main programming language used
  /// 
  /// Returns the name of the main language or null if analysis fails
  Future<String?> getMainLanguage(String folderPath) async {
    try {
      var res = await runCommand('tokei', [folderPath, '--output', 'json']);
      if (res.exitCode != 0) {
        logger.error('Error running Tokei: ${res.stderr}');
        return null;
      }
      
      return _parseLanguageOutput(res.stdout.toString());
    } catch (e) {
      logger.error('Error analyzing folder with Tokei', e);
      return null;
    }
  }
  
  /// Gets statistics for all languages in a folder
  /// 
  /// Returns a map of language statistics or null if analysis fails
  Future<Map<String, dynamic>?> getLanguageStats(String folderPath) async {
    try {
      var res = await runCommand('tokei', [folderPath, '--output', 'json']);
      if (res.exitCode != 0) {
        logger.error('Error running Tokei: ${res.stderr}');
        return null;
      }
      
      try {
        return json.decode(res.stdout.toString()) as Map<String, dynamic>;
      } catch (e) {
        logger.error('Failed to parse Tokei output', e);
        return null;
      }
    } catch (e) {
      logger.error('Error analyzing folder with Tokei', e);
      return null;
    }
  }
  
  /// Parses the JSON output from Tokei to determine the main language
  String? _parseLanguageOutput(String jsonOutput) {
    try {
      final jsonResult = json.decode(jsonOutput) as Map<String, dynamic>;
      String? mainLang;
      int maxCode = 0;
      
      for (final entry in jsonResult.entries) {
        final lang = entry.key;
        // Skip non-language entries
        if (lang == 'Total' || lang == 'JSON') continue;
        
        final stats = entry.value as Map<String, dynamic>;
        final code = stats['code'] as int? ?? 0;
        
        // Find language with the most code
        if (code > maxCode) {
          maxCode = code;
          mainLang = lang;
        }
      }
      
      return mainLang;
    } catch (e) {
      logger.error('Failed to parse Tokei output', e);
      return null;
    }
  }
  
  /// Checks if Tokei command is working correctly
  Future<bool> checkTokei() async {
    try {
      var res = await runCommand('tokei', ['--help']);
      return res.exitCode == 0;
    } catch (e) {
      logger.error('Error checking Tokei: ${e.toString()}');
      return false;
    }
  }
}