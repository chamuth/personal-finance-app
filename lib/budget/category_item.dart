import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/budget/income_expense.dart';
import 'package:personal_finance/shared/adder.dart';
import '../store/model.dart';
import 'mini_sum_status.dart';
import 'mini_transaction_statement.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    Key? key,
    required this.categoryName,
    required this.icon,
    required this.statements,
    required this.catId,
    this.type = IncomeExpense.income,
  }) : super(key: key);

  final int catId;
  final String categoryName;
  final Widget icon;
  final List<Statement> statements;
  final IncomeExpense type;

  @override
  State<StatefulWidget> createState() => CategoryItemState();
}

class CategoryItemState extends State<CategoryItem> {
  static const mainPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 10);

  @override
  Widget build(BuildContext context) {
    int? createSelectionType = widget.type == IncomeExpense.income ? 0 : 1;

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
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.type == IncomeExpense.income
                                    ? Colors.green
                                    : Colors.red)))),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: const [Text("Edit")],
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        widget.type == IncomeExpense.income
                            ? Colors.green
                            : Colors.red),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              MiniSumStatus(
                title:
                    widget.type == IncomeExpense.income ? "Income" : "Expense",
                type: widget.type,
                value: widget.statements.isNotEmpty
                    ? widget.statements
                        .map((x) => x.amount)
                        .reduce((v1, v2) => v1 + v2)
                    : null,
              ),
              MiniSumStatus(
                type: widget.type,
                title: widget.type == IncomeExpense.income ? "Goal" : "Budget",
              ),
              MiniSumStatus(
                type: widget.type,
                title: "To Reach",
              ),
            ],
          ),
          const Divider(
            color: Colors.transparent,
          ),
          if (widget.statements.isEmpty)
            Padding(
                child: Text(
                    widget.type == IncomeExpense.income
                        ? "No income this month"
                        : "No expense this month",
                    style: const TextStyle(color: Colors.grey)),
                padding: const EdgeInsets.symmetric(vertical: 15)),
          if (widget.statements.isNotEmpty)
            Column(
              children: widget.statements
                  .map<MiniTransactionStatement>((statement) {
                return MiniTransactionStatement(
                    title: statement.title,
                    description: statement.description,
                    amount: statement.amount,
                    type: widget.type);
              }).toList(),
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
                      onPressed: () => StatementAdder.addStatement(
                          context, createSelectionType,
                          initialSelectionCategory: widget.catId),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            widget.type == IncomeExpense.income
                                ? Colors.green
                                : Colors.red),
                      ),
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
