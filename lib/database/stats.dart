import 'dart:developer';

import 'package:faker/faker.dart';

import '../budget/income_expense.dart';
import '../store/model.dart';
import '../utils/month.dart';
import 'database.dart';

class StatReturn {
  final double total;
  final int month;

  StatReturn(this.total, this.month);
}

class Stats {
  static Future<List<StatReturn>> lastMonthCompare(
      {int? catId, IncomeExpense? type}) async {
    var db = DB.database!;

    //
    // for (var diff in [0, 1, 2, 3]) {
    //   for (var i = 0; i < 2; i++) {
    //     Statement.insert(
    //         db,
    //         Statement(
    //           title: faker.lorem.words(2).join(" "),
    //           description: faker.lorem.sentence(),
    //           amount: double.parse(
    //               faker.randomGenerator.integer(10000, min: 1000).toString()),
    //           created: MonthUtils.serialize(DateTime(
    //               DateTime.now().year, DateTime.now().month - diff, 5)),
    //           recurring: false,
    //           categoryId: 1,
    //           month: Statement.getMonth() - diff,
    //         ));
    //   }
    // }

    late List<Map<String, Object?>> data;

    if (catId != null) {
      data = await db.rawQuery(
          "SELECT SUM(amount) AS total, month FROM statement s WHERE s.category_id = ? GROUP BY s.month ORDER BY s.month ASC",
          [catId]);
    }

    if (type != null) {
      data = await db.rawQuery(
          "SELECT SUM(amount) AS total, month FROM statement s INNER JOIN category c ON s.category_id = c.id AND c.type_id = ? GROUP BY s.month ORDER BY s.month ASC",
          [type == IncomeExpense.income ? 0 : 1]);
    }

    if (type == null && catId == null) {
      data = await db.rawQuery(
          "SELECT SUM(amount) AS total, month FROM statement s INNER JOIN category c ON s.category_id = c.id AND c.type_id = 0 GROUP BY s.month ORDER BY s.month ASC");
    }

    return data
        .map<StatReturn>((x) => StatReturn(double.parse(x["total"].toString()),
            int.parse(x["month"].toString())))
        .toList();
  }
}
