import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:personal_finance/budget/category_item.dart';
import 'package:personal_finance/database/database.dart';
import 'package:personal_finance/shared/styles.dart';
import 'package:personal_finance/store/model.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../store/store.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Backgrounds.pageBackground,
        child: Padding(
            padding: mainPadding,
            child: Column(children: [
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
                  child: StoreConnector<AppStore, List<CategoryContent>>(
                      converter: (store) {
                        if (widget.mode == IncomeExpense.income) {
                          return store.state.incomeCategories;
                        }
                        return store.state.expenseCategories;
                      },
                      onInit: onInit,
                      builder: (ctx, cats) => ListView(
                          children: cats
                              .map((cat) => (CategoryItem(
                                  type: widget.mode,
                                  catId: cat.category.id,
                                  icon: Icon(Icons.business,
                                      color: widget.mode == IncomeExpense.income
                                          ? Colors.green
                                          : Colors.red),
                                  categoryName: cat.category.name,
                                  goal: cat.category.goal,
                                  statements: cat.statements)))
                              .toList())))
            ])));
  }

  void onInit(store) async {
    // empty
  }

  void createCategoryDialog(BuildContext context) {
    final titleController = TextEditingController();
    String? errorText;

    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: const Text("Create Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Category Name",
                        hintText: "Ex: Work",
                        errorText: errorText),
                    controller: titleController,
                  ),
                ],
              ),
              actions: <Widget>[
                StoreConnector<AppStore, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(DispatchType(
                        AppStoreActions.createCategory,
                        CreateCategoryType(
                            titleController.text,
                            widget.mode == IncomeExpense.income
                                ? "income"
                                : "expense")));
                  },
                  builder: (context, callback) {
                    return ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          setState(() {
                            errorText = "Empty category name";
                          });
                          return;
                        }
                        callback();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Create Category'),
                    );
                  },
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
