import 'package:flutter/material.dart';
import 'package:personal_finance/utils/currency.dart';

class MiniSumStatus extends StatelessWidget {
  const MiniSumStatus({Key? key, required this.title, required this.value})
      : super(key: key);

  final double value;
  final String title;

  static const TextStyle titleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(100, 0, 0, 0));
  static const TextStyle valueStyle = TextStyle(fontSize: 18, color: Color.fromARGB(255, 42, 150, 75));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text("LKR. ${Currency.format(value, cents: false)}", style: valueStyle))
      ],
    );
  }
}