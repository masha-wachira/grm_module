import 'package:flutter/material.dart';

class FormDisplayCard extends StatefulWidget {
  const FormDisplayCard(
      {required this.formNumber,
      required this.collectedBy,
      required this.collectionDate,
      required this.typeOfComplaint,
      required this.press,
        this.isFormComplete,
      super.key});

  final String formNumber;
  final String collectedBy;
  final String collectionDate;
  final String typeOfComplaint;
  final VoidCallback press;
  final bool? isFormComplete;

  @override
  State<FormDisplayCard> createState() => _FormDisplayCardState();
}

class _FormDisplayCardState extends State<FormDisplayCard> {
  @override
  Widget build(BuildContext context) {
    const String primaryFont = 'Poppins';
    final cardWidth = MediaQuery.of(context).size.width * 0.95;
    final cardHeight = MediaQuery.of(context).size.height * 0.13;
    return GestureDetector(
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
            padding: const EdgeInsets.only(top: 15, right: 0, left: 10),
                  child: SizedBox(
                    width: (cardWidth / 2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "${widget.formNumber}\n",
                                  style: const TextStyle(
                                    fontFamily: primaryFont,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  )),
                              WidgetSpan(
                                  child: SizedBox(height: cardHeight / 4)),
                              TextSpan(
                                text: "${widget.typeOfComplaint}\n",
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
                                  text: widget.collectedBy,
                                  style: TextStyle(
                                    fontFamily: primaryFont,
                                    color: Colors.grey[400],
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
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    width: (cardWidth / 2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Chip(
                          label: widget.isFormComplete! ? const Text('Form Completed'):const Text(' In Progress '),
                    labelStyle: const TextStyle(
                        color: Colors.white, fontFamily: primaryFont
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1.0,
                          backgroundColor: widget.isFormComplete! ? Colors.green:Colors.orange[900],
                          side: BorderSide.none,
                        ),
                        SizedBox(
                          height: cardHeight / 4,
                        ),
                        Text(
                          'Collected : ${widget.collectionDate}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.grey[400],
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
    );
  }
}
