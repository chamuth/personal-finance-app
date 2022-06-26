import 'package:flutter/material.dart';
import 'package:personal_finance/utils/currency.dart';

import 'income_expense.dart';

class MiniSumStatus extends StatelessWidget {
  const MiniSumStatus(
      {Key? key, required this.title, this.value, this.type = IncomeExpense
          .income})
      : super(key: key);

  final double? value;
  final String title;
  final IncomeExpense type;

  static const TextStyle titleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(100, 0, 0, 0));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
                "LKR. ${value != null
                    ? Currency.format(value!, cents: false)
                    : "-"}",
                style: type == IncomeExpense.income ? const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 42, 150, 75)) :
                const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 194, 48, 48))))
      ],
    );
  }
}
