import 'package:flutter/material.dart';
import 'package:personal_finance/budget/categoryItem.dart';
import 'package:personal_finance/shared/styles.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => IncomePageState();
}

class IncomePageState extends State<IncomePage> {
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
                  child: Row(children: [
                    const Expanded(child:
                      Text("Income Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                    ),
                    TextButton(
                      onPressed: () {  },
                      child: Row(children: const [
                        Padding(child: Icon(Icons.filter_alt, size: 18), padding: EdgeInsets.only(right: 5)),
                        Text("Filter")
                      ],)
                    )
                  ],),
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                ),
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
}
