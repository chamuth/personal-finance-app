import 'package:flutter/material.dart';
enum Status { good, bad }

class StatusItem extends StatelessWidget {
  const StatusItem(
      {Key? key,
      required this.title,
      required this.amount,
      required this.status})
      : super(key: key);

  final String title;
  final String amount;
  final Status status;


  @override
  Widget build(BuildContext context) {

    return Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
              Text(amount,
                  style: TextStyle(
                      color: status == Status.good ? Colors.green : Colors.red,
                      fontSize: 18)),

            ], crossAxisAlignment: CrossAxisAlignment.start)));
  }
}
