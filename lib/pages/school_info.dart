import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';
import 'package:kgs_mobile_v2/db/data_source.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kgs_mobile_v2/db/db_helper.dart';

class SchoolInfoPage extends StatefulWidget {
  const SchoolInfoPage({super.key});

  @override
  State<SchoolInfoPage> createState() => _SchoolInfoPageState();
}

class _SchoolInfoPageState extends State<SchoolInfoPage> {
  int _currentPage = 1;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final String tableName = 'school_information';
  List<SchoolsInfo> schools = [];
  int pageSize = 10;
  final DBHelper dbHelper = DBHelper();
  bool _isLoading=false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> fetchDataFromSQLTable(String table) async {
    setState(() {
      _isLoading = true;
    });
    final Database db = await databaseHelper.initDatabase();

    final String jsonString =
        await rootBundle.loadString('assets/school_info.json');
    final Map<String, dynamic> jsonMap =
        jsonDecode(jsonString) as Map<String, dynamic>;

    if (db.isOpen) {
      await dbHelper.insertData(db, table, jsonMap, 'rows');
      final tableData = await db.query(table) as List<dynamic>;

      final List<SchoolsInfo> schoolsHere = tableData
          .map((itemInMap) => SchoolsInfo.fromMapsList(itemInMap))
          .toList();

      setState(() {
        schools.addAll(schoolsHere);
        print(schools);
        _isLoading=false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception("There was an error getting data from the table");
    }
  }

  void loadData(){
    if (!_isLoading) {
      setState(() {
        _currentPage++;
      });
      fetchDataFromSQLTable(tableName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('School Information Page'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: PaginatedDataTable(
            header: const Text('Data Table Header'),
            rowsPerPage: pageSize,
            availableRowsPerPage: const [10, 25, 50],
            onRowsPerPageChanged: (value) {
              setState(() {
                pageSize = value!;
              });
            },
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Province ID')),
            ],
            source: DataSource(schools: schools),
          ),
        ),
      )
    );
  }
}
