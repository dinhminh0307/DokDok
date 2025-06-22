import 'dart:io';

import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/utils/platform_utils.dart';
import 'package:dokdok/services/process_run/common/process_logger.dart';
import 'package:path/path.dart' as path;

/// Interface for file creation operations
abstract class FileCreator {
  /// Creates a file at the specified path with optional content
  Future<File> createFile(String folderPath, String fileName, {String? content});
  
  /// Creates a folder at the specified path
  Future<Directory> createFolder(String folderPath);
  
  /// Checks if a file exists at the specified path
  Future<bool> fileExists(String filePath);
  
  /// Checks if a folder exists at the specified path
  Future<bool> folderExists(String folderPath);
}

/// Implementation of FileCreator for creating files on the filesystem
class CreateFileProcess implements FileCreator {
  final ProcessLogger logger;
  final PlatformType _platformType;
    /// Creates a new instance of the CreateFileProcess
  CreateFileProcess({required Log log}) 
      : logger = ProcessLogger(log, 'FileSystem'),
        _platformType = PlatformUtils.detectPlatformType() {
    logger.info('Initialized FileSystem handler for platform: ${PlatformUtils.getPlatformName()}');
  }
  
  /// Gets platform-specific temp directory
  Future<String> getTempDirectory() async {
    try {
      String tempPath = Directory.systemTemp.path;
      switch (_platformType) {
        case PlatformType.windows:
          break;
        case PlatformType.linux:
        case PlatformType.macOS:
        case PlatformType.other:
          // Use standard temp location
          break;
      }
      return tempPath;
    } catch (e) {
      logger.error('Error getting temp directory', e);
      return Directory.systemTemp.path; // Fallback
    }
  }
  
  /// Joins path segments in a platform-specific way
  String _joinPath(String folder, String file) {
    return path.join(folder, file);
  }
  
  /// Normalizes a path for the current platform
  String _normalizePath(String pathStr) {
    return path.normalize(pathStr);
  }
  
  @override
  Future<File> createFile(String folderPath, String fileName, {String? content}) async {
    try {
      // Normalize paths for the current platform
      final normalizedFolder = _normalizePath(folderPath);
      final filePath = _joinPath(normalizedFolder, fileName);
      
      // Check if folder exists
      Directory directory = Directory(normalizedFolder);
      if (!await directory.exists()) {
        logger.error('The specified folder does not exist: $normalizedFolder');
        throw Exception('Folder does not exist: $normalizedFolder');
      }
      
      // Create the file at the specified path
      File file = File(filePath);
      File result;
      
      if (content != null) {
        // Normalize line endings for the current platform
        final normalizedContent = content.replaceAll(RegExp(r'\r\n|\r|\n'), PlatformUtils.lineEnding);
        result = await file.writeAsString(normalizedContent);
      } else {
        result = await file.create();
      }
      
      logger.info('File created successfully at: ${file.path}');
      return result;
    } catch (e) {
      logger.error('Error creating file', e);
      rethrow;
    }
  }
  
  @override
  Future<Directory> createFolder(String folderPath) async {
    try {
      final normalizedPath = _normalizePath(folderPath);
      Directory directory = Directory(normalizedPath);
      if (await directory.exists()) {
        logger.info('Folder already exists at: $normalizedPath');
        return directory;
      }
      
      var result = await directory.create(recursive: true);
      logger.info('Folder created successfully at: $normalizedPath');
      return result;
    } catch (e) {
      logger.error('Error creating folder', e);
      rethrow;
    }
  }
  
  @override
  Future<bool> fileExists(String filePath) async {
    try {
      final normalizedPath = _normalizePath(filePath);
      File file = File(normalizedPath);
      return await file.exists();
    } catch (e) {
      logger.error('Error checking if file exists', e);
      return false;
    }
  }
  
  @override
  Future<bool> folderExists(String folderPath) async {
    try {
      final normalizedPath = _normalizePath(folderPath);
      Directory directory = Directory(normalizedPath);
      return await directory.exists();
    } catch (e) {
      logger.error('Error checking if folder exists', e);
      return false;
    }
  }
}