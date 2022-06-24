import 'package:sqflite/sqflite.dart';

class Category
{
  final int id;
  final String name;
  final String type;

  const Category({
    required this.id,
    required this.name,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name":  name,
      "type": type == "income" ? 0 : 1
    };
  }

  Future<List<Category>> all(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('category');

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'] == 0 ? "income" : "expense",
      );
    });
  }
}

class Statement {
  final int id;
  final String title;
  final String description;
  final double amount;
  final int month;
  final DateTime created;

  const Statement({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.month,
    required this.created
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title":  title,
      "description": description,
      "amount": amount,
      "month": month,
      "created": created
    };
  }

  Future<List<Statement>> all(Database db) async {
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