import 'package:flutter/material.dart';
import 'package:kgs_mobile_v2/db/db_helper.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class GetItemsHelper {
  List<String> schoolsList = [];
  List<String> provinceList = [];
  List<String> districtsList = [];
  List<String> cwacList = [];

  final DBHelper dbHelper = DBHelper();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> insertDataIntoTables() async {
    int? countSchool, countProvince, countDistrict, countCwac;

    final db = await databaseHelper.initDatabase();
    final schoolsJSON = await getDataFromJSON("assets/schools.json");
    final provincesJSON = await getDataFromJSON("assets/provinces.json");
    final districtsJSON = await getDataFromJSON("assets/districts.json");
    final cwacsJSON = await getDataFromJSON("assets/cwac.json");

    if (schoolsJSON.isEmpty &&
        provincesJSON.isEmpty &&
        districtsJSON.isEmpty &&
        cwacsJSON.isEmpty) {
      debugPrint("There was an error getting the data");
    } else {
      debugPrint("Data inserted successfully");
    }

    if (db.isOpen) {
      await dbHelper.insertData(db, 'school_information', schoolsJSON, "rows");
      countSchool = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM school_information'));
      debugPrint('The number of records are, $countSchool schools');

      await dbHelper.insertData(db, 'provinces', provincesJSON, "rows");
      countProvince = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM provinces'));
      debugPrint('The number of records are, $countProvince provinces');

      await dbHelper.insertData(db, 'districts', districtsJSON, "rows");
      countDistrict = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM districts'));
      debugPrint('The number of records are, $countDistrict districts');

      await dbHelper.insertData(db, 'cwac', cwacsJSON, "rows");
      countCwac=Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cwac'));
      print('The number of records are, $countCwac cwac' );
    }
  }

  Future<Map<String, dynamic>> getDataFromJSON(String jsonAssetPath) async {
    String jsonString = await rootBundle.loadString(jsonAssetPath);

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return jsonData;
  }

  Future<List<String>> getNameList(
      Database db, String tableName, String column, String key) async {
    Database db = await databaseHelper.initDatabase();
    final List<Map<String, dynamic>> columnMaps;

    if (db.isOpen) {
      columnMaps = await db.rawQuery('SELECT $column FROM $tableName');
      debugPrint("$columnMaps");

      final List<String> columnNames =
          columnMaps.map((map) => map[key] as String).toList();

      return columnNames;
    } else {
      throw Exception("There was an error getting list");
    }
  }

  Future<List<String>> getSchools() async {
    Database db = await databaseHelper.initDatabase();
    final List<Map<String, dynamic>> schoolData =
        await db.rawQuery('SELECT name FROM school_information');
    schoolsList = schoolData.map((map) => map['name'] as String).toList();
    debugPrint("$schoolsList");
    ;
    return schoolsList;
  }

  Future<List<String>> getProvinces() async {
    Database db = await databaseHelper.initDatabase();
    final List<Map<String, dynamic>> provinceData =
        await db.rawQuery('SELECT name FROM provinces');
    provinceList = provinceData.map((map) => map['name'] as String).toList();
    debugPrint("$provinceList");
    return provinceList;
  }

  Future<List<String>> getDistricts() async {
    Database db = await databaseHelper.initDatabase();
    final List<Map<String, dynamic>> districtData =
        await db.rawQuery('SELECT name FROM districts');
    districtsList = districtData.map((map) => map['name'] as String).toList();
    debugPrint("$districtsList");
    return districtsList;
  }

  Future<List<String>> getCwac() async {
    Database db = await databaseHelper.initDatabase();
    final List<Map<String, dynamic>> cwacData =
        await db.rawQuery('SELECT name FROM cwac');
    cwacList = cwacData.map((map) => map['name'] as String).toList();
    debugPrint("$cwacList");
    return cwacList;
  }
}
