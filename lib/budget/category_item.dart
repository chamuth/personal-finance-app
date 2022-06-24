import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/budget/mini_transaction_statement.dart';
import 'mini_sum_status.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({Key? key, required this.categoryName, required this.icon}) : super(key: key);

  final String categoryName;
  final Widget icon;

  @override
  State<StatefulWidget> createState() => CategoryItemState();
}

class CategoryItemState extends State<CategoryItem> {
  static const mainPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 10);

  static const categoryTitleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.icon,
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child:
                            Text(widget.categoryName, style: categoryTitleStyle))
                ),
                OutlinedButton(
                  onPressed: () {
                  },
                  child: Row(
                    children: const [
                      Text("Edit")
                    ],
                  )
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: const [
              MiniSumStatus(
                title: "Income",
                value: 210000 + 18000,
              ),
              MiniSumStatus(
                title: "Goal",
                value: 300000,
              ),
              MiniSumStatus(
                title: "To Reach",
                value: 300000 - 210000 - 18000,
              ),
            ],
          ),
          const Divider(
            color: Colors.transparent,
          ),
          ExpandablePanel(
            collapsed: const Opacity(child: MiniTransactionStatement(
              title: "Salary",
              description: "Bank of Ceylon",
              amount: 210000,
            ), opacity: 0.5),
            header: const Padding(child: Text("Show all statements", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.only(top:10, left: 9),),
            expanded: Column(
              children: [
                const MiniTransactionStatement(
                  title: "Salary",
                  description: "Bank of Ceylon",
                  amount: 210000,
                ),
                const MiniTransactionStatement(
                  title: "Tenant rental",
                  description: "Small house",
                  amount: 18000,
                ),
                const MiniTransactionStatement(
                  title: "Other income thingy",
                  description: "income other",
                  amount: 18000,
                ),
                const Divider(
                  color: Colors.transparent,
                  height: 8,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text("ADD RECORD"))
                                ])))
                  ],
                )
              ],
            )
          )


        ],
      ),
      padding: mainPadding,
    ));
  }
}
