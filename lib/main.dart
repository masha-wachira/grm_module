import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kgs_mobile_v2/components/schools_verified_component.dart';
import 'package:kgs_mobile_v2/pages/login.dart';
import 'package:kgs_mobile_v2/pages/school_info.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';
import 'package:kgs_mobile_v2/pages/splash_screen.dart';
import 'package:kgs_mobile_v2/components/listview_component.dart';
import '../pages/tab_view_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../db/hive_helper.dart';
import '../modules/GRM module/forms.dart';
import '../modules/GRM module/grm.dart';
import 'modules/GRM module/state_management/getx_state_manager.dart';


const String primaryFont = 'Poppins';


TextStyle customTextStyle({
  String fontFamily = primaryFont,
  double fontSize = 16.0,
  FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    color: color,
  );
}

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(DocAdapter());
  runApp(const ProviderScope(child: KgsMoge(),));
}

class KgsMoge extends StatelessWidget {
  const KgsMoge({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(FormsListController());
    ThemeData myTheme = Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: funGreen),
        useMaterial3: true,
        // tabBarTheme: myTheme.tabBarTheme.copyWith(
        //   indicator: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //     color: funGreen
        //   ),
        //   unselectedLabelColor: Colors.black,
        //   labelColor: ivroyWhite
        // ),
      ),
      home: GRMHome()
    );

  }
}
