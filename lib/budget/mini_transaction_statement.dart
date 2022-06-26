import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_finance/utils/currency.dart';

import 'income_expense.dart';

class MiniTransactionStatement extends StatelessWidget {
  const MiniTransactionStatement(
      {Key? key,
      required this.title,
      required this.description,
      required this.amount,
      this.type = IncomeExpense.income})
      : super(key: key);

  final String title;
  final String description;
  final double amount;
  final IncomeExpense type;

  static const TextStyle titleStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: type == IncomeExpense.income
                  ? const Color.fromARGB(20, 0, 100, 0)
                  : const Color.fromARGB(20, 100, 0, 0),
            ),
            child: Padding(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(title[0].toUpperCase()),
                      radius: 15,
                      foregroundColor: Colors.white,
                      backgroundColor: type == IncomeExpense.income
                          ? Colors.green
                          : Colors.red,
                    ),
                    const VerticalDivider(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: titleStyle),
                            Text(description,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: type == IncomeExpense.income
                                        ? const Color.fromARGB(180, 0, 60, 0)
                                        : const Color.fromARGB(180, 60, 0, 0)))
                          ]),
                    ),
                    Text(
                        "${type == IncomeExpense.income ? "+" : "-"} LKR. ${Currency.format(amount)}",
                        style: type == IncomeExpense.income
                            ? const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(150, 0, 50, 0))
                            : const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(150, 50, 0, 0)))
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10))));
  }
}
