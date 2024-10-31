import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../../db/kgs_db.dart';
import '../db/helper_functions.dart';
import '../models/grm_form_model.dart';
import 'package:sqflite/sqflite.dart';



  StateProvider formNumberProvider = StateProvider((ref) => '');
  StateProvider complaintAboutProvider = StateProvider((ref) => '');
  StateProvider complaintLodgedProvider = StateProvider((ref) => '');
  StateProvider collectionDateProvider = StateProvider((ref) => '');
  StateProvider collectedByProvider = StateProvider((ref) => '');
  StateProvider provinceProvider = StateProvider((ref) => '');
  StateProvider districtProvider = StateProvider((ref) => '');
  StateProvider cwacProvider = StateProvider((ref) => '');
  StateProvider schoolProvider = StateProvider((ref) => '');
  StateProvider genderProvider = StateProvider((ref) => '');
  StateProvider ageProvider = StateProvider((ref) => '');
  StateProvider complaintDetailsProvider = StateProvider((ref) => '');
  StateProvider complaintCategoryProvider = StateProvider((ref) => '');
  StateProvider complaintSubCategoryProvider = StateProvider((ref) => '');
  StateProvider grmFormsProvider = StateProvider((ref) => <GRMFormDetails>[]);
  StateProvider schoolsListProvider = StateProvider((ref) => <String>[]);
  StateProvider provincesListProvider = StateProvider((ref) => <String>[]);

  final listGrmFormsListProvider = StateNotifierProvider<ListGrmFormsListNotifier, List<Map<String, dynamic>>>((ref)=>ListGrmFormsListNotifier());



class ListGrmFormsListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final HelperFunctions helperFunctions = HelperFunctions();
  ListGrmFormsListNotifier() : super([]);

  void addForm(Map<String, dynamic> form) {
    state = [...state, form];
  }
  void setForms(List<Map<String, dynamic>> forms) async{
    state = forms;
    print("State Set: $state");
  }
}