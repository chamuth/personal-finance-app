import 'dart:developer';
import '../database/database.dart';
import 'model.dart';

class CategoryContent {
  final Category category;
  final List<Statement> statements;

  CategoryContent(this.category, this.statements);
}

class DispatchType {
  final AppStoreActions type;
  final dynamic payload;

  DispatchType(this.type, this.payload);
}

class CreateCategoryType {
  final String name;
  final String type;

  CreateCategoryType(this.name, this.type);
}

enum AppStoreActions { updateCategories, createCategory }

class AppStore {
  late List<CategoryContent> incomeCategories;
  late List<CategoryContent> expenseCategories;

  AppStore(this.incomeCategories, this.expenseCategories);

  static AppStore reducer(AppStore previous, action) {
    switch (action.type) {
      case AppStoreActions.updateCategories:
        var categories = action.payload;
        if (categories.length > 0) {
          var cats = categories
              .map<CategoryContent>((Category cat) =>
              CategoryContent(cat, []))
              .toList();

          if (categories[0].type == "income") {
            previous.incomeCategories = cats;
          } else {
            previous.expenseCategories = cats;
          }
        }
        break;
      case AppStoreActions.createCategory:
        String name = action.payload.name;
        String type = action.payload.type;

        var cat = Category(name: name, type: type);

        Category.insert(DB.database!, cat);

        if (action.payload.type == "income") {
          previous.incomeCategories
              .add(CategoryContent(Category(name: name, type: type), []));
        } else {
          previous.expenseCategories
              .add(CategoryContent(Category(name: name, type: type), []));
        }

        return previous;
    }

    return previous;
  }
}
