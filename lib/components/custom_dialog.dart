import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../main.dart';
import '../pages/tab_view_screen.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class CustomDialogBox extends StatelessWidget {
  TextEditingController textEditingController;
  final Function(Doc) updateDocsCallback;

  CustomDialogBox({
    super.key,
    required this.textEditingController,
    required this.updateDocsCallback
  });

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
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.45,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.58,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
            children: [
              TextFormField(
                controller: textEditingController,
                cursorColor: funGreen,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: customTextStyle(color: funGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: funGreen),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'The description is required'),
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: ()async{
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null &&
                      textEditingController.text.isNotEmpty) {
                    File file = File(result.files.single.path!);
                    String filePath = result.files.single.path!;
                    String fileName = path.basename(filePath);
                    Doc doc = Doc(
                      fileName: fileName,
                      description: textEditingController.text,
                      filePath: getFileTypeFromPath(filePath),
                    );
                    updateDocsCallback(doc);
                    Navigator.pop(context);
                  } else {
                    throw Exception("There was a problem picking file");
                  }
                },
                child: const Text("Upload doc"),
              )
            ]
        ),
      ),
    );
  }
}