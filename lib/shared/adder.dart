import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../store/model.dart';
import '../store/store.dart';
import '../utils/month.dart';

class StatementAdder {
  static void addStatement(BuildContext context, int _createSelectionType,
      {int? initialSelectionCategory = null}) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    bool isMonthly = false;
    int? createSelectedCategory = initialSelectionCategory;
    int createSelectionType = _createSelectionType;

    showDialog(
        context: context,
        builder: (BuildContext ctx) =>
            StatefulBuilder(builder: (BuildContext ctx, StateSetter setState) {
              return AlertDialog(
                title: const Text("Add new Income/Expense"),
                content: StoreConnector<AppStore, List<CategoryContent>>(
                    converter: (store) {
                      if (createSelectionType == 0) {
                        return store.state.incomeCategories;
                      }

                      return store.state.expenseCategories;
                    },
                    builder: (context, cats) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ToggleSwitch(
                              initialLabelIndex: createSelectionType,
                              totalSwitches: 2,
                              minWidth: 110,
                              inactiveBgColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              labels: const ['Income', 'Expense'],
                              onToggle: (index) {
                                setState(() {
                                  createSelectionType = index!;
                                });
                              },
                            ),
                            const Divider(),
                            DropdownButton<int>(
                                value: createSelectedCategory,
                                hint: Text(cats.isNotEmpty
                                    ? "Select category"
                                    : "No categories found"),
                                items: cats
                                    .map<DropdownMenuItem<int>>((cat) =>
                                        DropdownMenuItem(
                                            child: Text(cat.category.name +
                                                "(${cat.category.id})"),
                                            value: cat.category.id))
                                    .toList(),
                                onChanged: (v) => {
                                      setState(() {
                                        createSelectedCategory = v!;
                                      })
                                    }),
                            if (cats.isNotEmpty)
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Title",
                                  hintText: "Ex: Rental",
                                ),
                                controller: titleController,
                              ),
                            if (cats.isNotEmpty)
                              TextField(
                                  decoration: const InputDecoration(
                                      labelText: "Description",
                                      hintText: "Further describe"),
                                  controller: descriptionController),
                            if (cats.isNotEmpty)
                              TextField(
                                decoration: const InputDecoration(
                                    labelText: "Amount",
                                    prefixStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    prefixText: "LKR. "),
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            const Divider(),
                            if (cats.isNotEmpty)
                              CheckboxListTile(
                                title: const Text('Monthly'),
                                value: isMonthly,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isMonthly = value == true;
                                  });
                                },
                                secondary: const Icon(
                                    Icons.calendar_view_month_outlined),
                              )
                          ],
                        )),
                actions: <Widget>[
                  StoreConnector<AppStore, VoidCallback>(
                      converter: (store) {
                        return () => store.dispatch(DispatchType(
                            AppStoreActions.addStatement,
                            Statement(
                                title: titleController.text,
                                description: descriptionController.text,
                                amount: double.parse(amountController.text),
                                created: MonthUtils.serialize(DateTime.now()),
                                recurring: isMonthly == true,
                                categoryId: createSelectedCategory,
                                month: Statement.getMonth(),
                            )));
                      },
                      builder: (context, callback) => ElevatedButton(
                            onPressed: () {
                              callback();
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Add'),
                          )),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }));
  }
}
