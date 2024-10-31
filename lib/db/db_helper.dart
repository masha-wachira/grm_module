import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:kgs_mobile_v2/db/kgs_db.dart';



class DBHelper{
  final DatabaseHelper databaseHelper=DatabaseHelper();
  
  Future<void>insertData(Database db,String table,Map<String,dynamic> schools,String rows)async{
    final List<dynamic> schoolData=schools[rows];

    Batch batch = db.batch();
    for (var school in schoolData) {
      batch.insert(
        table,
        school,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    try {
      await batch.commit(noResult: true);
      print("Inserted sucessfully");
    } catch (error) {
      print("Error inserting batch data: $error");
    }
  }

  Future<Map<String,dynamic>> getDataFromJSON()async{

      String jsonString=await rootBundle.loadString("assets/school_info.json");

      Map<String, dynamic> jsonData=jsonDecode(jsonString);

      return jsonData;
  }
}