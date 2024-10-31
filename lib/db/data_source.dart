import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
import 'package:kgs_mobile_v2/db/db_helper.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';



class SchoolsInfo{
  final int id;
  final int provinceId;
  final String name;

  SchoolsInfo(
  {
    required this.id,
    required this.provinceId,
    required this.name});

  factory SchoolsInfo.fromMapsList(Map<String, dynamic> map) {
    return SchoolsInfo(
      id: map['id'],
      name: map['name'],
      provinceId: map['province_id'],
    );
  }

  final DatabaseHelper databaseHelper=DatabaseHelper();

}

class DataSource extends DataTableSource{

  final List<SchoolsInfo>schools;

  DataSource({required this.schools});

  @override
  DataRow? getRow(int index) {
    if (index >= schools.length) {
      return null;
    }

    final item = schools[index];

    return DataRow(cells: [
      DataCell(Text(item.id.toString())),
      DataCell(Text(item.name)),
      DataCell(Text(item.provinceId.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => schools.length;

  @override
  int get selectedRowCount => 0;
}
