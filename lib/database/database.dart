import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB
{
  static Database? database;

  void initialize() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "data.db"),
      onCreate: (db, version) {
        ct (sql) => db.execute(sql);

        /*
          income_category
          [id] 0
          [name] General Expenses
          [type_id] 1
        */
        ct(
          "CREATE TABLE category(id INTEGER PRIMARY KEY, name TEXT, type_id INTEGER)",
        );

        /*
          category_type
          [id] 0
          [type] income
        */
        ct(
          "CREATE TABLE category_type(id INTEGER PRIMARY KEY, type TEXT"
        );

        /*
          statement
          [id] 020
          [title] Salary
          [description] Bank of Ceylon
          [amount] +50000.0
          [month] 20 months (since 2000) for SQL querying
          [created] ISO time string
        */
        ct(
          "CREATE TABLE statement(id INTEGER PRIMARY KEY, title TEXT, description TEXT, amount REAL, month INTEGER, created TEXT"
        );
      },
      version: 1,
    );
  }

  Database getDb() {
    return database!;
  }
}
