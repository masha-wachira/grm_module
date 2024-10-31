import 'package:get/get.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';

import '../db/db_helper.dart';
import '../db/helper_functions.dart';
import 'package:sqflite/sqflite.dart';

class FormsListController extends GetxController {
  final RxList<Map<String, dynamic>> forms = RxList([]);
  HelperFunctions helperFunctions=HelperFunctions();
  final GRMDataBaseHelper grmDataBaseHelper=GRMDataBaseHelper();// Observable list

  // Database related functions
  Future<void> fetchAllData() async {
    Database db=await grmDataBaseHelper.initDatabase();
    final data = await helperFunctions.getAllTableData(db, 'grm_data');
    forms.value = data; // Update observable list with fetched data
  }
}