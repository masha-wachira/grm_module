import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../pages/tab_view_screen.dart';

class HiveHelper{

  Future<Box<Doc>> openDocsBox() async {
    final box = await Hive.openBox<Doc>('docs');
    return box;
  }

  Future<void> addDocToList(Doc doc) async {
    final box = await openDocsBox();
    await box.put(box.length, doc); // Use box.length for auto-incrementing key
  }

  Future<List<Doc>> getDocsList() async {
    final box = await openDocsBox();
    return box.values.toList();
  }

  Future<void> deleteDoc(int index) async {
    final box = await openDocsBox();
    if (index >= 0 && index < box.length) {
      await box.delete(index);
    } else {
      // Handle invalid index (optional)
      print("Error: Index out of range");
    }
  }
}

class DocAdapter extends TypeAdapter<Doc> {
  @override
  final int typeId = 0; // Matches the typeId in Doc class

  @override
  Doc read(BinaryReader reader) {
    final fieldName = reader.readString();
    final fieldDescription = reader.readString();
    final fieldPath = reader.readString();
    return Doc(
      fileName: fieldName,
      description: fieldDescription,
      filePath: fieldPath,
    );
  }

  @override
  void write(BinaryWriter writer, Doc obj) {
    writer.writeString(obj.fileName);
    writer.writeString(obj.description);
    writer.writeString(obj.filePath);
  }
}