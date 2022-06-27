import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:personal_finance/shared/styles.dart';

import '../store/store.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Backgrounds.pageBackground,
        child: ListView(children: [
          StoreConnector<AppStore, List<CategoryContent>>(
              converter: (store) => store.state.incomeCategories,
              builder: (context, List<CategoryContent> cats) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: cats.map((cat) => catCard(cat)).toList())))
        ]));
  }

  Widget catCard(CategoryContent cat) {
    return Card(
        child: Padding(
            child: Row(
              children: [
                Expanded(
                  child: Text(cat.category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text("No goals set", style: TextStyle(color: Color.fromARGB(255, 150, 150, 150)))
              ],
            ),
            padding: const EdgeInsets.all(10)));
  }
}
