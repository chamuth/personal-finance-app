import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_finance/budget/categoryItem.dart';
import 'package:personal_finance/database/database.dart';
import 'package:personal_finance/shared/styles.dart';
import 'package:personal_finance/store/model.dart';

enum IncomeExpense { income, expense }

class IncomeExpensePage extends StatefulWidget {
  const IncomeExpensePage({Key? key, required this.mode}) : super(key: key);

  final IncomeExpense mode;

  @override
  State<StatefulWidget> createState() => IncomeExpensePageState();
}

class IncomeExpensePageState extends State<IncomeExpensePage> {
  static const mainPadding = EdgeInsets.all(5);

  @override
  Widget build(BuildContext context) {

    return Container(
        color: Backgrounds.pageBackground,
        child: Padding(
            padding: mainPadding,
            child: Column(
              children: [
                Padding(
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${widget.mode == IncomeExpense.income ? "Income" : "Expense"} Categories",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                        OutlinedButton(
                            onPressed: () => createCategoryDialog(context),
                            child: Row(
                              children: const [
                                Padding(
                                    child: Icon(Icons.add, size: 18),
                                    padding: EdgeInsets.only(right: 5)),
                                Text("Create Category")
                              ],
                            )),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8)),
                Expanded(
                    child: ListView(
                  children: const [
                    CategoryItem(
                      icon: Icon(Icons.business, color: Colors.green),
                      categoryName: "General Income",
                    ),
                    CategoryItem(
                      icon: Icon(Icons.person, color: Colors.green),
                      categoryName: "Side Hustle 😩",
                    ),
                  ],
                ))
              ],
            )));
  }

  void createCategory(String name) async
  {
    var cat = Category(
      name: name,
      type: widget.mode == IncomeExpense.income ? "income": "expense"
    );

    await Category.insert(DB.database!, cat);
    log("Inserted category");
  }

  void createCategoryDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: const Text("Create Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Category Name", hintText: "Ex: Work"),
                    controller: titleController,
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    createCategory(titleController.text);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Create Category'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }
}
