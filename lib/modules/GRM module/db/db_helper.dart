import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class GRMDataBaseHelper {
  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'grm_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    db.execute('''
    CREATE TABLE IF NOT EXISTS grm_data (
    id INTEGER PRIMARY KEY,
    form_number TEXT,
    complaint_about TEXT,
    complaint_lodged TEXT,
    collection_date TEXT,
    collected_by TEXT,
    province TEXT,
    district TEXT,
    cwac TEXT,
    school TEXT,
    gender TEXT,
    age TEXT,
    complaint_details TEXT,
    complaint_category TEXT,
    complaint_sub_category TEXT,
    is_form_complete TEXT
    )
    ''');
    print('GRM Form Table created successfully');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}
}
