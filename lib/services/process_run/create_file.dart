import 'dart:io';

import 'package:dokdok/services/process_run/interface.dart';

class CreateFileProcess extends BaseProcess {
  CreateFileProcess(super.logger);

  Future<File> createFile(String folderPath, String fileName, String? content) async {
    try {
      // log error if folderPath is not exist
      Directory directory = Directory(folderPath);
      if (!await directory.exists()) {
        logger.error('The specified folder does not exist: $folderPath');
        throw Exception('Folder does not exist: $folderPath');
      }
      
      // Create the file at the specified path
      File file = File('${folderPath}/${fileName}');
      var res;
      if (content != null) {
        res = await file.writeAsString(content);
      } else {
        res = await file.create();
      }
      
      logger.info('File created successfully at: ${file.path}');
      return res;
    } catch (e) {
      logger.error('Error creating file: $e');
      rethrow;
    }
  }
}