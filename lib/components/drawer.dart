import 'package:flutter/material.dart';
import 'package:kgs_mobile_v2/pages/home.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

import '../main.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  String userEmail = 'johndoe@gmail.com';
  String userCompanyName = 'KGS';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userCompanyName,
              style: customTextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userEmail,
              style: customTextStyle(
                  color: Colors.white, fontStyle: FontStyle.italic),
            ),
            currentAccountPicture: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.0,
                  child: Container(
                    height: 55.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(''),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: funGreen,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_rounded,
              color: funGreen,
            ),
            title: Text(
              'Home',
              style: customTextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          //identification  and enrolment
          ExpansionTile(
            leading: const Icon(
              Icons.description_rounded,
              color: funGreen,
            ),
            title: Text(
              'Identification and Enrolment',
              style: customTextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              //navigate to the 2 screens you'll create in identification module @peter
              ListTile(
                title: const Text('School based'),
                onTap: () {
                  null;
                },
              ),
              ListTile(
                title: const Text('Community based'),
                onTap: () {
                  null;
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //payment
          ListTile(
            leading: const Icon(
              Icons.monetization_on_rounded,
              color: funGreen,
            ),
            title: Text(
              'Payment Verification',
              style: customTextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              null;  // don't touch this
            },
          ),
          const SizedBox(
            height: 20,
          ),
          //GRM
          ListTile(
            leading: const Icon(
              Icons.cases_rounded,
              color: funGreen,
            ),
            title: Text(
              'GRM',
              style: customTextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              null; //navigate to the screen you'll create in identification module @Alpha
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: funGreen,
            ),
            title: Text(
              'Logout',
              style: customTextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              null;
            },
          ),
        ],
      ),
    );
  }
}

