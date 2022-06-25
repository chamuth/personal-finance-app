import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../store/model.dart';
import 'mini_sum_status.dart';
import 'mini_transaction_statement.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem(
      {Key? key,
      required this.categoryName,
      required this.icon,
      required this.statements})
      : super(key: key);

  final String categoryName;
  final Widget icon;
  final List<Statement> statements;

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
                        child: Text(widget.categoryName,
                            style: categoryTitleStyle))),
                OutlinedButton(
                    onPressed: () {},
                    child: Row(
                      children: const [Text("Edit")],
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: const [
              MiniSumStatus(
                title: "Income",
              ),
              MiniSumStatus(
                title: "Goal",
              ),
              MiniSumStatus(
                title: "To Reach",
              ),
            ],
          ),
          const Divider(
            color: Colors.transparent,
          ),
          if (widget.statements.isEmpty)
            const Padding(
                child: Text("No income this month",
                    style: TextStyle(color: Colors.grey)),
                padding: EdgeInsets.symmetric(vertical: 15)),

          if (widget.statements.isNotEmpty)
            ExpandablePanel(
                collapsed: Opacity(
                    child: MiniTransactionStatement(
                      title: widget.statements[0].title,
                      description: widget.statements[0].description,
                      amount: widget.statements[0].amount,
                    ),
                    opacity: 0.5),
                header: Padding(
                  child: Text("Show all statements (${widget.statements.length})",
                      style:
                          const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  padding: const EdgeInsets.only(top: 10, left: 9),
                ),
                expanded: Column(
                  children: widget.statements
                      .map<MiniTransactionStatement>((statement) {
                    return MiniTransactionStatement(
                      title: statement.title,
                      description: statement.description,
                      amount: statement.amount,
                    );
                  }).toList(),
                )),
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
      ),
      padding: mainPadding,
    ));
  }
}
