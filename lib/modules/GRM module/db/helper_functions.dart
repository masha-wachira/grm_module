import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class HelperFunctions {
  Future<void> insertData(Database db, String table, Map<String, dynamic> formData) async {
    try {
      await db.insert(table, formData,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("Inserted sucessfully");
    } catch (error) {
      print("Error inserting batch data: $error");
    }
  }

  Future<List<Map<String, dynamic>>> getAllTableData(
      Database db, String table) async {
    final List<Map<String, dynamic>> tableData;
    try {
      tableData = await db.query(table);
      debugPrint('$tableData');
      return tableData;
    } catch (error) {
      debugPrint("Error getting data: $error");
      throw Exception("There was an error getting data");
    }
  }
}
