import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kgs_mobile_v2/main.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

class ListViewComponent extends StatefulWidget {
  ListViewComponent(
      {super.key,
      required this.imgPath,
      required this.description,
      required this.imgName,
      required this.press,
      required this.isFormComplete});

  final String imgPath;
  final String imgName;
  final String description;
  bool isFormComplete;
  final VoidCallback press;

  @override
  State<ListViewComponent> createState() => _ListViewComponentState();
}

class _ListViewComponentState extends State<ListViewComponent> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.95;
    final cardHeight = MediaQuery.of(context).size.height * 0.13;
    return GestureDetector(
      onTap: widget.press,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: cardHeight,
            width: cardWidth,
            child: Card(
              elevation: 1.5,
              color: Colors.blue.withOpacity(0.07),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        backgroundImage: AssetImage(widget.imgPath),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '${widget.imgName}\n',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: primaryFont,
                                fontSize: 18),
                          ),
                          WidgetSpan(
                            child: SizedBox(height: cardHeight / 4),
                          ),
                          TextSpan(
                            text:
                                " ${widget.description}\n", // Add space for better separation
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: primaryFont,
                                fontSize: 14),
                          ),
                          WidgetSpan(
                            child: SizedBox(height: cardHeight / 4),
                          ),
                          const TextSpan(
                            text:
                                "CHILAMBOBWE PRIMARY SCHOOL\n", // Add space for better separation
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: primaryFont,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    Chip(
                      label: widget.isFormComplete
                          ? const Text('Completed')
                          : const Text(' In Progress '),
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2.0,
                      backgroundColor: widget.isFormComplete
                          ? Colors.green
                          : Colors.red[400],
                      side: BorderSide.none,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
