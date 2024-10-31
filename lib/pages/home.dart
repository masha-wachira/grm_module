import 'package:flutter/material.dart';
import 'package:kgs_mobile_v2/main.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

import '../components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kgs home', style: customTextStyle(color: ivoryWhite),),
        backgroundColor: funGreen,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                size: 30,
                color: ivoryWhite,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
        drawer: MyDrawer(),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('welcome to the kgs home page'))
        ],
      ),
    );
  }
}
