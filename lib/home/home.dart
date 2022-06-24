import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_finance/home/statusItem.dart';
import 'package:personal_finance/shared/styles.dart';
import 'package:personal_finance/utils/currency.dart';

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

            Padding(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.6,
                  children: [
                    StatusItem(
                        title: "Income this month",
                        amount: "LKR. ${Currency.format(15000, cents: true)}",
                        status: Status.good),
                    const StatusItem(
                        title: "Spending this month",
                        amount: "LKR. 2300.00",
                        status: Status.bad),
                    const StatusItem(
                        title: "Income this month",
                        amount: "+2%",
                        status: Status.good),
                    const StatusItem(
                        title: "Spending this month",
                        amount: "-5%",
                        status: Status.good),
                    const StatusItem(
                        title: "Transport spending",
                        amount: "+20%",
                        status: Status.bad),
                    const StatusItem(
                        title: "Food spending",
                        amount: "+15%",
                        status: Status.bad),
                  ],
                ),
                padding: const EdgeInsets.all(10))
          ],
        ));
  }
}
