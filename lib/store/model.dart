import 'package:personal_finance/budget/income_expense.dart';
import 'package:sqflite/sqflite.dart';

class Category {
  final int id;
  final String name;
  final String type;

  const Category({this.id = 0, required this.name, required this.type});

  Map<String, dynamic> toMap() {
    return {"name": name, "type_id": type == "income" ? 0 : 1};
  }

  static Future<List<Category>> all(Database db, IncomeExpense mode) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM category WHERE type_id=?',
        [mode == IncomeExpense.income ? 0 : 1]);

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type_id'] == 0 ? "income" : "expense",
      );
    });
  }

  static Future insert(Database db, Category category) async {
    return db.insert("category", category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}

class Statement {
  final int id;
  final String title;
  final String description;
  final double amount;
  final int month;
  final DateTime created;

  const Statement(
      {this.id = 0,
      required this.title,
      required this.description,
      required this.amount,
      required this.month,
      required this.created});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "amount": amount,
      "month": month,
      "created": created
    };
  }

  static Future<List<Statement>> all(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return Statement(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        month: maps[i]['month'],
        created: maps[i]['created'],
      );
    });
  }
}
