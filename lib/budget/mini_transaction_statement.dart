import 'package:flutter/material.dart';
import 'package:personal_finance/utils/currency.dart';

class MiniTransactionStatement extends StatelessWidget {
  const MiniTransactionStatement({Key? key, required this.title, required this.description, required this.amount}) : super(key: key);

  final String title;
  final String description;
  final double amount;

  static const TextStyle titleStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  static const TextStyle subStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(180, 0, 60, 0));
  static const TextStyle valueStyle = TextStyle(fontSize: 15, color: Color.fromARGB(150, 0, 50, 0));


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(20, 0, 100, 0),
        ),
        child: Padding(
          child: Row(
            children: [
              CircleAvatar(child: Text(title[0].toUpperCase()), radius: 15),
              VerticalDivider(width: 10),
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title, style: titleStyle),
                Text(description, style: subStyle)
              ]),
              ),
              Text("+ LKR. ${Currency.format(amount)}", style: valueStyle)
            ],)
        , padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10)
      ))
    );
  }
}
