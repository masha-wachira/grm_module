import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/components/form_display_card.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/db/db_helper.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/db/helper_functions.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/state_management/getx_state_manager.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';
import '../GRM module/forms.dart';
import '../GRM module/get_items_helper.dart';
import '../GRM module/state_management/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class GRMHome extends ConsumerWidget {
  GRMHome({super.key});

  List provinceList = [];
  List districtsList = [];
  List cwacList = [];

  final GetItemsHelper getItemsHelper = GetItemsHelper();
  final GRMDataBaseHelper grmDataBaseHelper = GRMDataBaseHelper();
  final HelperFunctions helperFunctions = HelperFunctions();

  Future<void> getData(WidgetRef ref) async {
    final schoolsList = ref.read(schoolsListProvider);
    final provincesList = ref.read(provincesListProvider);
    debugPrint("yeees");
    try {
      await getItemsHelper.insertDataIntoTables();
      schoolsList.clear(); // Clear existing data before assigning new data
      provincesList.clear();
      schoolsList.addAll(await getItemsHelper.getSchools());
      provincesList.addAll(await getItemsHelper.getProvinces());
    } on Exception catch (e) {
      debugPrint('An error occurred while fetching data: $e');
    }
  }

  void getDataToPopulateListView(WidgetRef ref) async {
    final formDataToPopulateListView;
    Database db = await grmDataBaseHelper.initDatabase();
    // formDataToPopulateListView=await helperFunctions.getAllTableData(db, 'grm_data');
    // print(formDataToPopulateListView);
    List<Map<String, dynamic>> data =
        await helperFunctions.getAllTableData(db, 'grm_data');
    ref.read(listGrmFormsListProvider.notifier).setForms(data);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = Get.find<FormsListController>();
    controller.fetchAllData();
    getDataToPopulateListView(ref);
    final listGrmFormsToPopulateListView = ref.read(listGrmFormsListProvider);
    final schoolsList = ref.watch(schoolsListProvider);
    final provincesList = ref.watch(provincesListProvider);
    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GRMForm(
          provinceLists: provincesList,
          schoolsLists: schoolsList,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1); // Slide from the bottom
          const end = Offset.zero;
          const curve = Curves.easeOut;
          const duration = Duration(seconds: 5);

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(seconds: 2),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("GRM Home"),
      ),
      body: Obx(() => ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: controller.forms.length,
            itemBuilder: (BuildContext context, int index) {
              final form = controller.forms[index];
              return FormDisplayCard(
                formNumber: form['form_number'] ?? 'Unknown',
                collectedBy: form['collected_by'] ?? 'Unknown',
                collectionDate: form['collection_date'] ?? 'Unknown',
                typeOfComplaint: form['complaint_about'] ?? 'Unknown',
                isFormComplete: bool.parse(form['is_form_complete']?? false),
                press: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 2500),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 2500),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        const begin = Offset(0, 1); // Slide from the bottom
                        const end = Offset.zero;
                        const curve = Curves.bounceInOut;
                        const duration = Duration(seconds: 5);

                        final tween =
                        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                            position: offsetAnimation,
                            child: GRMForm(
                              provinceLists: provincesList,
                              schoolsLists: schoolsList,
                              id: form['id'],
                              formNumber: form['form_number'],
                              complaintAbout: form['complaint_about'],
                              complaintLodged: form['complaint_lodged'],
                              collectionDate: form['collection_date'],
                              collectedBy: form['collected_by'],
                              province: form['province'],
                              district: form['district'],
                              cwac: form['cwac'],
                              school: form['school'],
                              gender: form['gender'],
                              age: form['age'],
                              complaintDetails: form['complaint_details'],
                              complaintCategory: form['complaint_category'],
                              complaintSubCategory:
                              form['complaint_sub_category'],
                            ));
                      }
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int int) {
              return const SizedBox(
                height: 10,
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getData(ref);
          Navigator.of(context).push(createRoute());
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
