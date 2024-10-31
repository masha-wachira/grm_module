import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kgs_mobile_v2/db/db_helper.dart';

class DatabaseHelper {
  static Database? _database;
  String schoolTable = 'school_information';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'kgs_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('KGS Database created successfully.');

    // Create tables here
    //Creating a new school info database here
    db.execute('''
    CREATE TABLE school_information(
    id INTEGER PRIMARY KEY,
    name TEXT,
    code TEXT,
    province_id INTEGER,
    district_id INTEGER,
    constituency_id INTEGER,
    cwac_id INTEGER,
    latitude INTEGER,
    longitude INTEGER,
    school_type_id_old INTEGER,
    school_type_id INTEGER,
    facility_type_id INTEGER,
    postal_address TEXT,
    email_address TEXT,
    telephone_no INTEGER,
    physical_address INTEGER,
    mobile_no INTEGER,
    description TEXT,
    created_by TEXT,
    created_at TEXT,
    updated_at TEXT,
    updated_by TEXT,
    facility_location_id INTEGER,
    facility_manager_id INTEGER,
    facility_check1 INTEGER,
    facility_check2 INTEGER,
    facility_check3 INTEGER,
    running_agency_id INTEGER
    )
    ''');
    db.execute('''
    CREATE TABLE districts (
    id INTEGER PRIMARY KEY,
    province_id INTEGER,
    debs_id INTEGER,
    grm_focalperson_id INTEGER,
    name TEXT,
    code TEXT,
    description TEXT,
    created_at TEXT,
    created_by INTEGER,
    updated_at TEXT,
    updated_by INTEGER,
    prevrecord_id INTEGER
    )
    ''');
    db.execute('''
    CREATE TABLE cwac (
    id INTEGER PRIMARY KEY,
    province_id INTEGER,
    district_id INTEGER,
    ward_id INTEGER,
    name TEXT,
    code TEXT,
    description TEXT,
    contact_person_id INTEGER,
    contact_person_name TEXT,
    contact_person_phone TEXT,
    created_at TEXT,
    created_by INTEGER,
    updated_at TEXT,
    updated_by INTEGER,
    prevrecord_id INTEGER
    )
    ''');

    db.execute('''
    CREATE TABLE provinces (
    id INTEGER PRIMARY KEY,
    name TEXT,
    code TEXT,
    description TEXT,
    created_at TEXT,
    created_by INTEGER,
    updated_at TEXT,
    updated_by INTEGER,
    prevrecord_id INTEGER
    )
    ''');
    db.execute('''
    CREATE TABLE IF NOT EXISTS grm_data (
    id INTEGER PRIMARY KEY,
    form_number TEXT UNIQUE,
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
    print('Grm forms table created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database updated from version $oldVersion to $newVersion.');

    // Add more upgrade logic for higher versions as needed
  }
}
