import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_finance/budget/income_expense.dart';
import 'package:personal_finance/home/status_item.dart';
import 'package:personal_finance/shared/styles.dart';
import 'package:personal_finance/utils/currency.dart';

import '../database/stats.dart';
import '../store/store.dart';
import '../utils/calculations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static List<double?> stats = [];
  static List<double?> catStats = [];

  Future loadStats() async {
    var income = await Stats.lastMonthCompare(type: IncomeExpense.income);
    var expense = await Stats.lastMonthCompare(type: IncomeExpense.expense);

    setState(() {
      stats = [
        (income.last.total / income[income.length - 2].total) * 100,
        expense.isNotEmpty
            ? (expense.last.total / expense[expense.length - 2].total) * 100
            : null
      ];
    });
  }

  Future loadCatStats() async {
    for (var i = 3; i < 5; i ++) {
      var sta = await Stats.lastMonthCompare(catId: i);
      setState(() {
        catStats.add(
            (sta.last.total / sta[sta.length - 2].total) * 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const grapherPadding = EdgeInsets.only(top: 40, bottom: 25);

    if (stats.isEmpty) loadStats();
    if (catStats.isEmpty) loadCatStats();

    return Container(
        color: Backgrounds.pageBackground,
        child: ListView(
          children: [
            // Progress bars
            StoreConnector<AppStore, List<List<double>>>(
              converter: (store) {
                var inc =
                    Calculations.goalCalculate(store.state.incomeCategories);
                var exp =
                    Calculations.goalCalculate(store.state.expenseCategories);

                return [inc, exp];
              },
              builder: (ctx, calculations) => Padding(
                  padding: grapherPadding,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (calculations[0].isNotEmpty)
                          CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 10.0,
                            percent: calculations[0][0] / calculations[0][1],
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    child: Text("Income goals"),
                                    padding: EdgeInsets.only(bottom: 5)),
                                Text(
                                  "LKR ${Currency.format(calculations[0][0], cents: false)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green),
                                ),
                                Text(
                                  "/ LKR ${Currency.format(calculations[0][1], cents: false)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            progressColor: Colors.green,
                          ),
                        if (calculations[1].isNotEmpty)
                          CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 10.0,
                            percent: calculations[1][0] / calculations[1][1],
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    child: Text("Budget spent"),
                                    padding: EdgeInsets.only(bottom: 5)),
                                Text(
                                  "LKR ${Currency.format(calculations[1][0], cents: false)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red),
                                ),
                                Text(
                                  "/ LKR ${Currency.format(calculations[1][1], cents: false)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            progressColor: Colors.red,
                          ),
                      ])),
            ),

            StoreConnector<AppStore, AppStore>(
                converter: (store) => store.state,
                builder: (context, store) => Padding(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.4,
                      children: [
                        StatusItem(
                            title: "Income this month",
                            amount:
                                "LKR. ${Calculations.categorySumProcessor(store.incomeCategories)}",
                            status: Status.good),
                        StatusItem(
                            title: "Spending this month",
                            amount:
                                "LKR. ${Calculations.categorySumProcessor(store.expenseCategories)}",
                            status: Status.bad),
                        if (stats[0] != null) incomePercentage(0),
                        if (stats[1] != null) incomePercentage(1),
                        for (var i = 0; i < store.expenseCategories.length; i++)
                          expensePercentage(i, str: "${store.expenseCategories[i].category.name} spending")
                      ],
                    ),
                    padding: const EdgeInsets.all(10)))
          ],
        ));
  }

  Widget incomePercentage(int i, {String? str}) {
    var value = stats[i]! - 100;
    var sign = value > 0 ? "+" : (value < 0? "-" : "");

    return StatusItem(
        title: str ?? (i == 0 ? "Income this month" : "Expense this month"),
        amount: "$sign${Currency.truncateDigits(value)}%",
        status: sign == "+" && i == 0 ? Status.good : Status.bad);
  }

  Widget expensePercentage(int i, {String? str}) {
    var value = catStats[i]! - 100;
    var sign = value > 0 ? "+" : (value < 0? "-" : "");

    return StatusItem(
        title: str ?? (i == 0 ? "Income this month" : "Expense this month"),
        amount: "$sign${Currency.truncateDigits(value)}%",
        status: sign == "-" ? Status.good : Status.bad);
  }

}
