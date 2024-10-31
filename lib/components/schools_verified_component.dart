import 'package:flutter/material.dart';

class FormDisplayCard extends StatefulWidget {
  const FormDisplayCard(
      {required this.emisSchoolCode,
        required this.submittedBy,
        required this.submittedOn,
        required this.schoolName,
        required this.press,
        required this.verified,
        super.key});

  final String emisSchoolCode;
  final String submittedBy;
  final String submittedOn;
  final String schoolName;
  final VoidCallback press;
  final int verified;

  @override
  State<FormDisplayCard> createState() => _FormDisplayCardState();
}

class _FormDisplayCardState extends State<FormDisplayCard> {
  @override
  Widget build(BuildContext context) {
    const String primaryFont = 'Poppins';
    final cardWidth = MediaQuery.of(context).size.width * 0.95;
    final cardHeight = MediaQuery.of(context).size.height * 0.13;
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: widget.press,
          child: Center(
            child: SizedBox(
              height: cardHeight,
              width: cardWidth,
              child: Card(
                color: Colors.blue.withOpacity(0.2),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
                      child: SizedBox(
                        width: (cardWidth / 2.5),
                        child: Column(
                          children: [
                            RichText(
                                softWrap: false,
                                overflow: TextOverflow.visible,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Emis code: ${widget.emisSchoolCode}\n",
                                      style: const TextStyle(
                                        fontFamily: primaryFont,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      )),
                                  WidgetSpan(
                                      child: SizedBox(height: cardHeight / 4)),
                                  TextSpan(
                                    text: "${widget.schoolName}\n",
                                    style: const TextStyle(
                                      fontFamily: primaryFont,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  WidgetSpan(
                                      child: SizedBox(height: cardHeight / 4)),
                                  TextSpan(
                                      text: 'Submitted By: ${widget.submittedBy}',
                                      style: TextStyle(
                                        fontFamily: primaryFont,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ))
                                ]))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth / 7.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: (cardWidth / 2.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Chip(
                              label:const Text(
                                  'Verified Beneficiaries: 25/45',
                                overflow: TextOverflow.visible,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: primaryFont
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 1.0,
                              backgroundColor:Colors.orange[900],
                              side: BorderSide.none,
                            ),
                            SizedBox(
                              height: cardHeight / 3,
                            ),
                            Text(
                              'Collected : ${widget.submittedOn}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontFamily: primaryFont,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )
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
