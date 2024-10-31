import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';
import 'package:kgs_mobile_v2/main.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/components/date_component.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/components/drop_down_text_field.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/db/helper_functions.dart';
import 'package:kgs_mobile_v2/modules/GRM%20module/state_management/getx_state_manager.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../GRM module/get_items_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import '../GRM module/components/basic_text_field.dart';
import '../GRM module/state_management/providers.dart';
import '../GRM module/models/grm_form_model.dart';
import '../GRM module/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'components/get_image_dialog.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image_picker/image_picker.dart';

class GRMForm extends StatefulWidget {
  GRMForm(
      {required this.schoolsLists,
      required this.provinceLists,
      this.id,
      this.formNumber,
      this.complaintAbout,
      this.complaintLodged,
      this.collectionDate,
      this.collectedBy,
      this.province,
      this.district,
      this.cwac,
      this.school,
      this.gender,
      this.age,
      this.complaintDetails,
      this.complaintCategory,
      this.complaintSubCategory});

  String? formNumber,
      complaintAbout,
      complaintLodged,
      collectionDate,
      collectedBy,
      province,
      district,
      cwac,
      school,
      gender,
      age,
      complaintDetails,
      complaintCategory,
      complaintSubCategory;
  int? id;

  List schoolsLists = [];
  List provinceLists = [];

  @override
  State<GRMForm> createState() => _GRMFormState();
}

class _GRMFormState extends State<GRMForm> {
  final TextEditingController formNumberController = TextEditingController();
  final TextEditingController complaintAboutController = TextEditingController();
  final TextEditingController complaintLodgedController = TextEditingController();
  final TextEditingController collectionDateController = TextEditingController();
  final TextEditingController collectedByController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cwacController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController complaintDetailsController = TextEditingController();
  final TextEditingController complaintSubCategoryController = TextEditingController();
  final TextEditingController complaintCategoryController = TextEditingController();

  String? fileName;
  Uint8List fileBytes=Uint8List(0);

  void preFillForm() {
    formNumberController.text = widget.formNumber ?? ' ';
    complaintAboutController.text = widget.complaintAbout ?? ' ';
    complaintLodgedController.text = widget.complaintLodged ?? ' ';
    collectionDateController.text = widget.collectionDate ?? ' ';
    collectedByController.text = widget.collectedBy ?? ' ';
    provinceController.text = widget.province ?? ' ';
    districtController.text = widget.district ?? ' ';
    cwacController.text = widget.cwac ?? ' ';
    schoolController.text = widget.school ?? ' ';
    genderController.text = widget.gender ?? ' ';
    ageController.text= widget.age ?? ' ';
    complaintDetailsController.text = widget.complaintDetails ?? ' ';
    complaintSubCategoryController.text = widget.complaintSubCategory ?? ' ';
    complaintCategoryController.text = widget.complaintCategory ?? ' ';
  }

  List<Map<String, dynamic>> formDataToPopulateDB = [];
  List newDistrictList = [];
  List newCwacList = [];
  final String primaryFont = 'Poppins';
  final List testList = ['Alpha', 'Alvin', 'Maina', 'Kinyua', 'Josh', 'Atteh'];
  final GetItemsHelper getItemsHelper = GetItemsHelper();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final GRMDataBaseHelper grmDataBaseHelper = GRMDataBaseHelper();
  final HelperFunctions helperFunctions = HelperFunctions();
  String? stringToBuild;
  int? provinceId;
  int? districtId;
  bool _isComplete = false;

  final _formKey = GlobalKey<FormState>();
  final List complaintsAbout = [
    'Keeping Girls In School',
    'Supporting Women Livelihood',
    'Other'
  ];
  final List collectedByList = [
    'Samson Mwelwa',
    'Matthew Mwansa',
    'John Kamwele',
    'Eric Zuze',
    'Chapamoyo Simwaba',
    'Isaac Lijimu',
    'Charity Mukuma',
    'Sapito Kayombo'
  ];
  final List genderList = ['Male', 'Female'];
  final List complaintCategoryList = [
    'Exclusion',
    'Inclusion',
    'Payment',
    'Service Standards',
    'Training & Mentorship',
    'Serious Complaints',
    'Corruption & Fraud',
    'Other'
  ];

  Future<int> itemID(String valueSelected, String tableName) async {
    final db = await databaseHelper.initDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [valueSelected],
    );

    if (maps.isNotEmpty) {
      // print(maps);
      return maps
          .first['id']; // Assuming 'id' is the column name for the identifier
    } else {
      throw Exception("An error occurred"); // No province found with that name
    }
  }

  Future<List<dynamic>> getItems(
      int itemId, String tableName, String columnName) async {
    final db = await databaseHelper.initDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnName = ?',
      whereArgs: [itemId],
    );
    // print(maps);
    return maps.map((map) => map['name'] as String).toList();
  }

  Future<void> insertGRMForms(
      Database db, List<GRMFormDetails> grmFormsList) async {
    int count;
    print("getting count");
    await db.transaction((txn) async {
      for (final formDetails in grmFormsList) {
        await txn.insert('grm_data', formDetails.toMap(formDetails));
      }
      final countQuery = await txn.rawQuery('SELECT COUNT(*) FROM grm_data');
      count = Sqflite.firstIntValue(countQuery)!;
      // debugPrint('$count');
    });
  }

  void setGrmFormList(WidgetRef ref, Database db) async {
    List<Map<String, dynamic>> data =
        await helperFunctions.getAllTableData(db, 'grm_data');
    debugPrint('$data');
    ref.read(listGrmFormsListProvider.notifier).setForms(data);
  }

  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile == null) {
      throw Exception('There was an Error picking file');
    } else {
      final file = File(pickedFile.files.first.path!);
      final filePath = file.path;
      setState(() {
        fileName=path.basename(filePath);
      });
      fileBytes = await file.readAsBytes();
      setState(() {});
      print(filePath);
    }
  }
  void _showGetImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetImageDialog(
          imageFromDeviceOnPress: () async{
            await pickFile();
            Navigator.of(context).pop();
          },
          imageFromCameraOnPress: () async{
            try {
              final imagePicker = ImagePicker();
              final XFile? pickedImageFile=await imagePicker.pickImage(source: ImageSource.camera);
              if(pickedImageFile!=null){
                final imagePath=pickedImageFile.path;
                setState(() {
                  fileName=path.basename(imagePath);
                });
                fileBytes=await pickedImageFile.readAsBytes();
                setState(() {});
              }
            } catch (e) {
              print('Error capturing image: $e');
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preFillForm();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormsListController>();
    String primaryFont = 'Poppins';

    return WillPopScope(
    onWillPop: () async {
      bool shouldExit = await _showExitConfirmationDialog();
      return shouldExit;
    },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: funGreen,
            title: Text("GRM Form",
                style: TextStyle(
                    fontFamily: primaryFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: ivoryWhite))),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
                  ExpansionTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    collapsedBackgroundColor: Colors.blue.withOpacity(0.1),
                    initiallyExpanded: true,
                    title: Center(
                      child: Text(
                        "Grievance Details",
                        style: TextStyle(
                            fontFamily: primaryFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 13,
                              ),
                              //...................................Form Number................................................//

                              LabelTextStyle(labelText: 'Form Number:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              BasicTextField(
                                controller: formNumberController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This is a required field';
                                    }
                                    return null;
                                  }),
                              const SizedBox(
                                height: 10,
                              ),

                              //..............What is the complain about form field.......................................//
                              LabelTextStyle(
                                  labelText: 'What is the Complaint About*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: complaintAboutController.text,
                                dropDownItems: complaintsAbout,
                                onChanged: (value) {
                                  complaintAboutController.text = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              //..............Date when complaint was lodged field.......................................//
                              LabelTextStyle(
                                  labelText: 'Date when complaint was lodged:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DateSelect(
                                dateController: complaintLodgedController,
                                onDateSelected: (value) {
                                  String dateString =
                                      '${value.year}-0${value.month}-0${value.day}';
                                  complaintLodgedController.text = dateString;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //..............Complaint Collection Date.......................................//
                              LabelTextStyle(
                                  labelText: 'Complaint Collection Date:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DateSelect(
                                dateController: collectionDateController,
                                onDateSelected: (value) {
                                  String dateString =
                                      '${value.year}-0${value.month}-0${value.day} ';
                                  setState(() {
                                    collectionDateController.text = dateString;
                                  });
                                },
                                // initialValue: collectionDateController.text,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //....................Complaint Collected By.......................................//
                              LabelTextStyle(
                                  labelText: 'Complaint Collected by:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                dropDownItems: collectedByList,
                                onChanged: (value) {
                                  setState(() {
                                    collectedByController.text = value!;
                                  });
                                },
                                initialValue: collectedByController.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              /*........................................Province Field............................................................*/
                              LabelTextStyle(labelText: 'Province:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: provinceController.text,
                                dropDownItems: widget.provinceLists,
                                onChanged: (selectedItem) async {
                                  debugPrint("Selected item: $selectedItem");
                                  provinceId =
                                      await itemID(selectedItem, 'provinces');
                                  newDistrictList = await getItems(
                                      provinceId!, 'districts', 'province_id');
                                  setState(() {
                                    provinceController.text = selectedItem;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              /*........................................District Field............................................................*/
                              LabelTextStyle(labelText: 'District:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: districtController.text,
                                dropDownItems: [],
                                asyncItems: (String filter) async {
                                  return newDistrictList;
                                },
                                onChanged: (selectedItem) async {
                                  print("$selectedItem");
                                  districtId =
                                      await itemID(selectedItem, 'districts');
                                  newCwacList = await getItems(
                                      districtId!, 'cwac', 'district_id');
                                  setState(() {
                                    districtController.text = selectedItem!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              /*........................................CWAC Field............................................................*/
                              LabelTextStyle(labelText: 'Cwac:*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: cwacController.text,
                                dropDownItems: [],
                                asyncItems: (String filter) async {
                                  return newCwacList;
                                },
                                onChanged: (selectedItem) async {
                                  print("$selectedItem");
                                  setState(() {
                                    cwacController.text = selectedItem!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),
                              /*........................................School Field............................................................*/
                              LabelTextStyle(labelText: 'School*'),
                              const SizedBox(height: 3),
                              DropdownTextField(
                                initialValue: schoolController.text,
                                dropDownItems: widget.schoolsLists,
                                onChanged: (selectedItem) async {
                                  setState(() {
                                    schoolController.text = selectedItem;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              /*........................................Gender Field............................................................*/
                              LabelTextStyle(labelText: 'Gender*'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: genderController.text,
                                dropDownItems: genderList,
                                onChanged: (value) {
                                  setState(() {
                                    genderController.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              /*........................................Age Field............................................................*/
                              LabelTextStyle(labelText: 'Age*'),
                              const SizedBox(
                                height: 3,
                              ),
                              BasicTextField(
                                controller: ageController,
                                // initialValue: widget.age,
                                onChanged: (value) {
                                  setState(() {
                                    ageController.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                softWrap: true,
                                "Complaint Details (Type in the complaint EXACTLY as the complainant wrote it. If it is written in a local language, please include both the original text and an English translation):",
                                style: TextStyle(
                                  fontFamily: primaryFont,
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              /*........................................Complaint Details Field............................................................*/
                              LabelTextStyle(labelText: 'Complaint Details:'),
                              const SizedBox(
                                height: 3,
                              ),
                              BasicTextField(
                                controller: complaintDetailsController,
                                // initialValue: widget.complaintDetails,
                                onChanged: (value) {
                                  setState(() {
                                    complaintDetailsController.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              /*........................................Complaint Category Field............................................................*/
                              LabelTextStyle(labelText: 'Complaint Category:'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: complaintCategoryController.text,
                                dropDownItems: complaintCategoryList,
                                onChanged: (selectedItem) async {
                                  setState(() {
                                    complaintCategoryController.text = selectedItem;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              /*............................................Complaint Sub Category....................................................*/
                              LabelTextStyle(
                                  labelText: 'Complaint Sub-Category:'),
                              const SizedBox(
                                height: 3,
                              ),
                              DropdownTextField(
                                initialValue: complaintSubCategoryController.text,
                                dropDownItems: complaintCategoryList,
                                onChanged: (selectedItem) async {
                                  setState(() {
                                    complaintSubCategoryController.text = selectedItem;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This is a required field';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 650,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          child: StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: funGreen),
                                                ),
                                              ),
                                              controller: TextEditingController(text: fileName ?? "NO FILE YET"),
                                              readOnly: true,
                                            );
                                          }),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15,
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              _showGetImageDialog(context);
                                            },
                                            child: Text(
                                              'Upload Image',
                                              style: TextStyle(
                                                fontFamily: primaryFont,
                                                fontSize: 12,
                                              ),
                                            ))
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              const SizedBox(height: 15)
                            ]),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  //..................................COMPLAINANT DETAILS FORM.........................................................//
                  /*........................................First Name Field............................................................*/
                  ExpansionTile(
                    collapsedBackgroundColor: Colors.blue.withOpacity(0.1),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Center(
                      child: Text(
                        "Complainant Details (If Provided)",
                        style: TextStyle(
                            fontFamily: primaryFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelTextStyle(labelText: 'First Name:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            /*........................................Last Name Field............................................................*/
                            LabelTextStyle(labelText: 'Last Name:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            /*........................................Village Field............................................................*/
                            LabelTextStyle(labelText: 'Village:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            /*........................................Mobile Number Field............................................................*/
                            LabelTextStyle(labelText: 'Mobile Number:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.integer(
                                    errorText: "A valid number is required"),
                              ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            /*........................................Email Address Field............................................................*/
                            LabelTextStyle(labelText: 'Email Address:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.email(
                                    errorText: "Enter a valid email address")
                              ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            /*.......................NRC Number of SWL beneficiary or SCTS(KGS) household head Field..............................*/
                            LabelTextStyle(
                                labelText:
                                    'NRC Number of SWL beneficiary or SCTS(KGS) household head:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //.........................................KGS BENEFICIARY INFO.........................................................//

                  ExpansionTile(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    collapsedBackgroundColor: Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Center(
                      child: Text(
                        "KGS Beneficiary Only (If Provided)",
                        style: TextStyle(
                            fontFamily: primaryFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    children: [
                      /*........................................Beneficiary ID Field............................................................*/
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelTextStyle(labelText: 'Beneficiary ID'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            /*........................................First Name Field............................................................*/
                            LabelTextStyle(labelText: 'First Name:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            /*........................................Last Name Field............................................................*/
                            LabelTextStyle(labelText: 'Last Name:'),
                            const SizedBox(
                              height: 3,
                            ),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //..............Date of Birth Field.......................................//
                            LabelTextStyle(labelText: 'Date of Birth:'),
                            const SizedBox(
                              height: 3,
                            ),
                            DateSelect(onDateSelected: (value) {
                              String dateString =
                                  '${value.year}-0${value.month}-0${value.day} ';
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ExpansionTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    collapsedBackgroundColor: Colors.blue.withOpacity(0.1),
                    title: Center(
                      child: Text(
                        "Household Details (If Provided)",
                        style: TextStyle(
                            fontFamily: primaryFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelTextStyle(labelText: 'HHH NRC:'),
                            const SizedBox(height: 5),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            LabelTextStyle(labelText: 'HHH First Name'),
                            const SizedBox(height: 5),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            LabelTextStyle(labelText: 'HHH Last Name'),
                            const SizedBox(height: 5),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                            LabelTextStyle(labelText: 'HH# in CWAC:'),
                            const SizedBox(height: 5),
                            BasicTextField(
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height:
                          MediaQuery.of(context).size.height * 0.04,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ??
                                  false) {
                                setState(() {
                                  _isComplete = true;
                                });
                              } else {
                                setState(() {
                                  _isComplete = false;
                                });
                              }
                              debugPrint('$_isComplete');
                              Map<String, dynamic> map;
                              var grmFormDetails = {
                                  'id': widget.id,
                                  'form_number': formNumberController.text,
                                  'complaint_about': complaintAboutController.text,
                                  'complaint_lodged': complaintLodgedController.text,
                                  'collection_date': collectionDateController.text,
                                  'collected_by': collectedByController.text,
                                  'province': provinceController.text,
                                  'district': districtController.text,
                                  'cwac': cwacController.text,
                                  'school': schoolController.text,
                                  'gender': genderController.text,
                                  'age': ageController.text,
                                  'complaint_details': complaintDetailsController.text,
                                  'complaint_category': complaintCategoryController.text,
                                  'complaint_sub_category': complaintSubCategoryController.text,
                                  'is_form_complete': _isComplete.toString()
                              };
                              Database db = await grmDataBaseHelper.initDatabase();
                              debugPrint('This is the map to be inserted $grmFormDetails');
                              final dataFromDB=await db.query(
                                'grm_data',
                                where: 'id = ?',
                                whereArgs: [widget.id]
                              );
                              if(dataFromDB.isEmpty){
                                helperFunctions.insertData(db, 'grm_data', grmFormDetails);
                              }
                              // int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM grm_data'));
                              // print(count);
                              // controller.fetchAllData();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: funGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30))),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: ivoryWhite,
                                fontSize: 15,
                                fontFamily: primaryFont,
                              ),
                            ),
                          ),
                        ),
                      ),
                ]),
              )),
        ),
      ),
    );
  }
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Confirm Exit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you wish to leave without saving? This might lead to losing your progress',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismiss the dialog and do not exit
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              child: Text(
                'Stay',
                style: customTextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Exit the screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              child: Text(
                'Exit',
                style: customTextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dialog is dismissed by other means
  }
}

class LabelTextStyle extends StatefulWidget {
  LabelTextStyle({required this.labelText, super.key});

  String labelText;

  @override
  State<LabelTextStyle> createState() => _LabelTextStyleState();
}

class _LabelTextStyleState extends State<LabelTextStyle> {
  @override
  Widget build(BuildContext context) {
    String primaryFont = 'Poppins';
    return Text(
      widget.labelText,
      textAlign: TextAlign.start,
      style: customTextStyle(color: Colors.grey),
    );
  }
}
