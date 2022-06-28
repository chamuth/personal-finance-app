import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_finance/home/status_item.dart';
import 'package:personal_finance/shared/styles.dart';
import 'package:personal_finance/utils/currency.dart';

import '../database/database.dart';
import '../store/model.dart';
import '../store/store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const grapherPadding = EdgeInsets.only(top: 40, bottom: 25);

    return Container(
        color: Backgrounds.pageBackground,
        child: ListView(
          children: [
            // Progress bars
            Padding(
                padding: grapherPadding,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularPercentIndicator(
                        radius: 75.0,
                        lineWidth: 10.0,
                        percent: 0.8,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                                child: Text("Savings"),
                                padding: EdgeInsets.only(bottom: 3)),
                            Text(
                              "+ LKR 25,000",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        progressColor: Colors.green,
                      ),
                      CircularPercentIndicator(
                        radius: 75.0,
                        lineWidth: 10.0,
                        percent: 0.8,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                                child: Text("Budget spent"),
                                padding: EdgeInsets.only(bottom: 3)),
                            Text(
                              "80%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        progressColor: Colors.red,
                      ),
                    ])),

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
                                "LKR. ${categorySumProcessor(store.incomeCategories)}",
                            status: Status.good),
                        StatusItem(
                            title: "Spending this month",
                            amount:
                                "LKR. ${categorySumProcessor(store.expenseCategories)}",
                            status: Status.bad),
                        const StatusItem(
                            title: "Income this month",
                            amount: "+2%",
                            status: Status.good),
                        const StatusItem(
                            title: "Spending this month",
                            amount: "-5%",
                            status: Status.good),

                        for(var i = 0; i < store.expenseCategories.length; i ++)
                          StatusItem(
                            title: "${store.expenseCategories[i].category.name} spending",
                            amount: "+20%",
                            status: Status.bad)
                      ],
                    ),
                    padding: const EdgeInsets.all(10)))
          ],
        ));
  }

  String categorySumProcessor(List<CategoryContent> cats) {
    var validCats = cats.where((x) => x.statements.isNotEmpty);

    if (validCats.isEmpty) {
      return "-";
    }

    var amount = validCats
        .map<double>((x) =>
            x.statements.map((y) => y.amount).reduce((v1, v2) => v1 + v2))
        .reduce((v1, v2) => v1 + v2);
    return Currency.format(amount, cents: true);
  }
}
