import 'dart:typed_data';

import 'package:flutter/material.dart';

class GRMFormDetails{
  final String formNumber, collectedBy,province, district, cwac,
      school, gender, age,complaintAbout,complaintLodged,collectionDate;

  String? complaintDetails, complaintCategory, complaintSubCategory,isFormComplete;
  int? id;
  Uint8List? fileBytes;

  GRMFormDetails({
    this.id,
    required this.formNumber,
    required this.complaintAbout,
    required this.complaintLodged,
    required this.collectionDate,
    required this.collectedBy,
    required this.province,
    required this.district,
    required this.cwac,
    required this.school,
    required this.gender,
    required this.age,
    this.complaintCategory,
    this.complaintDetails,
    this.complaintSubCategory,
    this.isFormComplete,
    this.fileBytes
  });
  Map<String, dynamic>toMap(GRMFormDetails objectInstance){
    return{
      'id':objectInstance.id,
      'form_number': objectInstance.formNumber,
      'complaint_about':objectInstance.complaintAbout,
      'complaint_lodged':objectInstance.complaintLodged,
      'collection_date':objectInstance.collectionDate,
      'collected_by':objectInstance.collectedBy,
      'province':objectInstance.province,
      'district':objectInstance.district,
      'cwac':objectInstance.cwac,
      'school':objectInstance.school,
      'gender':objectInstance.gender,
      'age':objectInstance.age,
      'complaint_category':objectInstance.complaintCategory,
      'complaint_details':objectInstance.complaintDetails,
      'complaint_sub_category':objectInstance.complaintSubCategory,
      'is_form_complete':objectInstance.isFormComplete,
    };
  }
}