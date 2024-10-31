import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/tab_view_screen.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class TabViewController extends GetxController{

  String getFileTypeFromPath(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'assets/images/image_icon.png';
      case '.png':
        return 'assets/images/image_icon.png';
      case '.pdf':
        return 'assets/images/doc_icon.png';
      case '.txt':
        return 'assets/images/doc_icon.png';
    // Add more cases for other extensions as needed
      default:
        return 'assets/images/unknown_icon.png';
    }
  }

  Future<List<Doc>> addDocToList(TextEditingController descriptionController, ) async{
    Doc doc;
    List<Doc> docs=[];
    FilePickerResult? result =
    await FilePicker.platform.pickFiles();

    if (result != null &&
        descriptionController.text.isNotEmpty) {
      File file = File(result.files.single.path!);
      String filePath = result.files.single.path!;
      String fileName = path.basename(filePath);
      Doc doc = Doc(
        fileName: fileName,
        description: descriptionController.text,
        filePath: getFileTypeFromPath(filePath),
      );
      docs.add(doc);
      return docs;
    } else {
      throw Exception("There was a problem picking file");
    }
  }
}