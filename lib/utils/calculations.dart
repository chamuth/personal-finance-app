import '../store/store.dart';
import 'currency.dart';

class Calculations {
  static List<double> goalCalculate(List<CategoryContent> content) {
    var toReduce =
    content.where((x) => x.category.goal != null).map<List<double>>((x) {
      if (x.statements.isEmpty) {
        return [0, x.category.goal ?? 0];
      }

      double amount =
      x.statements.map((y) => y.amount).reduce((v1, v2) => v1 + v2);

      return [amount, x.category.goal ?? 0];
    });

    if (toReduce.isEmpty) {
      return [];
    }

    return toReduce.reduce((v1, v2) => [v1[0] + v2[0], v1[1] + v2[1]]);
  }

  static String categorySumProcessor(List<CategoryContent> cats) {
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