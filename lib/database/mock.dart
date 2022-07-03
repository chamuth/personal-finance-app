import 'package:sqflite/sqflite.dart';

import '../store/model.dart';
import '../utils/month.dart';

class Mock
{
  static void mockData(Database db)
  {
    var i = (String ct,  double? goal) => db.insert("category", Category(
      type: "income",
      name: ct,
      goal: goal
    ).toMap());

    var e = (String ct, double? goal) => db.insert("category", Category(
        type: "expense",
        name: ct,
        goal: goal
    ).toMap());

    var st = (String name, String description, double amount, int cat, bool rec, {DateTime? created, int? offset}) => db.insert("statement", Statement(
      title: name,
      description: description,
      amount: amount,
      categoryId: cat,
      recurring: rec,
      month: Statement.getMonth() - (offset ?? 0),
      created: MonthUtils.serialize(created ?? DateTime.now()),
    ).toMap());

    i("Work", 100000); //1
    i("Rental", 40000); //2

    e("Food", 30000);
    e("Transportation", 15000);
    e("Education", null);

    // data
    st("Salary", "BOC", 60000, 1, false);
    st("Bonus", "BOC", 22000, 1, false);

    st("Store rent", "From Building #2", 15000, 2, true);

    st("Dinner out", "PizzaHut", 5000, 3, false);
    st("Food delivery", "Lunch", 4500, 3, false);

    st("Train ticket", "20 x 2 x 100", 20 * 2 * 105, 4, true);
    st("Petrol 15l", "motorbike", 420 * 15, 4, false);

    // last month
    var lm = DateTime(2022, 06, 20);
    st("Salary", "BOC", 60000, 1, false, created: lm, offset: 1);
    st("Bonus", "BOC", 15000, 1, false, created: lm, offset: 1);

    st("Takeouts", "KFS", 8000, 3, false, created: lm, offset: 1);
    st("Birthday party", "my birthday", 6500, 3, false, created: lm, offset: 1);
    st("Treats for work", "birthday", 3000, 3, false, created: lm, offset: 1);

    st("Petrol 15l", "motorbike", 380 * 15, 4, false, created: lm, offset: 1);

    var lm2 = DateTime(2022, 05, 20);
    st("Salary", "BOC", 60000, 1, false, created: lm2, offset: 2);
    st("Bonus", "BOC", 20000, 1, false, created: lm2, offset: 2);

    st("Takeouts", "KFS", 8000, 3, false, created: lm2, offset: 2);
    st("Birthday party", "my birthday", 5000, 3, false, created: lm2, offset: 2);
    st("Treats for work", "birthday", 3000, 3, false, created: lm2, offset: 2);

    st("Petrol 15l", "motorbike", 320 * 15, 4, false, created: lm2, offset: 2);
  }
}
