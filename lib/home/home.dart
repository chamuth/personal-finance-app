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
  @override
  Widget build(BuildContext context) {
    const grapherPadding = EdgeInsets.only(top: 40, bottom: 25);

    Stats.lastMonthCompare();

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
                        const StatusItem(
                            title: "Income this month",
                            amount: "+5%",
                            status: Status.good),
                        const StatusItem(
                            title: "Spending this month",
                            amount: "-5%",
                            status: Status.good),
                        for (var i = 0; i < store.expenseCategories.length; i++)
                          StatusItem(
                              title:
                                  "${store.expenseCategories[i].category.name} spending",
                              amount: "+20%",
                              status: Status.bad)
                      ],
                    ),
                    padding: const EdgeInsets.all(10)))
          ],
        ));
  }
}
