// const _expenseCategories = [
//   _CategoryOption('Food', Palette.clay, Icons.local_cafe_rounded),
//   _CategoryOption(
//       'Transport', Palette.slate, Icons.directions_bus_filled_rounded),
//   _CategoryOption('Wellness', Palette.sage, Icons.spa_rounded),
//   _CategoryOption('Shopping', Palette.gold, Icons.shopping_bag_rounded),
//   _CategoryOption('Misc', Palette.muted, Icons.receipt_long_rounded),
// ];

// const _incomeCategories = [
//   _CategoryOption('Salary', Palette.teal, Icons.account_balance_wallet_rounded),
//   _CategoryOption('Freelance', Palette.slate, Icons.work_outline_rounded),
//   _CategoryOption('Gift', Palette.clay, Icons.card_giftcard_rounded),
//   _CategoryOption('Other', Palette.muted, Icons.savings_rounded),
// ];

import 'package:flutter/material.dart';
import 'package:habit_tracker/Core/themes/app_themes.dart';

InputDecoration decoration(
  Color isAccent, {
  String? hint,
  String? prefixText,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    prefixText: prefixText,
    prefixStyle:
        const TextStyle(fontWeight: FontWeight.w700, color: Palette.ink),
    filled: true,
    fillColor: Palette.surface,
    border: border(Palette.hairline),
    enabledBorder: border(Palette.hairline),
    focusedBorder: border(isAccent, 1.6),
    errorBorder: border(Colors.redAccent.shade100),
    focusedErrorBorder: border(Colors.redAccent, 1.6),
  );
}
