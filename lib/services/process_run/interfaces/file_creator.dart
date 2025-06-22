import 'dart:io';

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