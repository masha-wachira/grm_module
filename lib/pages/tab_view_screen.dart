import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/colors.dart';
import '../components/custom_dialog.dart';
import '../components/listview_component.dart';
import 'package:get/get.dart';
import '../controllers/tabview_controller.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import '../db/hive_helper.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  final TextEditingController descriptionController = TextEditingController();
  final TabViewController controller = Get.put(TabViewController());
  List<Doc> docs = [];
  late TabController _tabController;
  final HiveHelper hiveHelper=HiveHelper();


  void getData()async{
    List<Doc> boxDocs;
    boxDocs=await hiveHelper.getDocsList();

    setState(() {
      docs=boxDocs;
    });
  }
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Tab View'),
        backgroundColor: const Color(0xffe0ede6),
      ),
      body: Column(
        children: [
          const SizedBox(height:10),
          Material(
            child: Container(
              height: 70,
              color: ivoryWhite,
              child: TabBar(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: funGreen,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: funGreen, width: 1)),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Tab A"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: funGreen, width: 1)),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Tab B"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const SizedBox(),
                docs.isEmpty
                    ? const Center(
                        child: SpinKitPulsingGrid(
                        color: Color(0xff9df4d1),
                        size: 50.0,
                      ))
                    : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 2),
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: ListViewComponent(
                                press: (){},
                                imgPath: docs[index].filePath,
                                description: docs[index].description,
                                imgName: docs[index].fileName,
                                isFormComplete: true,
                              ),
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.45,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.58,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2),
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  color: Colors.white),
                                              child: Image.asset(
                                                docs[index].filePath,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(docs[index].fileName),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(docs[index].description),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                                onPressed: ()async {
                                                  List<Doc> updatedDocsList;
                                                  await hiveHelper.deleteDoc(index);
                                                  updatedDocsList=await hiveHelper.getDocsList();

                                                  setState(() {
                                                    docs=updatedDocsList;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text("Delete Item"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialogBox(
                textEditingController: descriptionController,
                updateDocsCallback: (Doc newDoc) async{
                  List<Doc>boxDocs;
                  await hiveHelper.addDocToList(newDoc);
                  boxDocs=await hiveHelper.getDocsList();
                  setState((){
                    docs=boxDocs;
                  });
                } // Close the dialog after file selection
                ),
          );
        },
      ),
    );
  }
}

@HiveType(typeId: 0)
class Doc extends HiveObject{
  @HiveField(0)
  final String fileName;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String filePath;

  Doc(
      {required this.fileName,
      required this.description,
      required this.filePath});


  String toJson() {
    return jsonEncode({
      'fileName': fileName,
      'filePath': filePath,
      'description': description,
    });
  }
}
