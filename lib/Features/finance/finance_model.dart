import 'package:flutter/material.dart';

class ExpenseSheetModel {
  double amount;
  String title;
  String note;
  String dateTime;
  String categoryName;
  String status;

  ExpenseSheetModel({
    required this.amount,
    required this.title,
    required this.note,
    required this.dateTime,
    required this.categoryName,
    required this.status,
  });
}

class CategoryOption {
  const CategoryOption(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}
