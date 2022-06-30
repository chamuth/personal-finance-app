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

class GoalUpdateType {
  final int id;
  final double goal;

  GoalUpdateType(this.id, this.goal);
}

enum AppStoreActions {
  updateCategories,
  createCategory,
  addStatement,
  updateTimeFrame,
  updateCategoryGoal
}

class Timeframe {
  final int year;
  final int month;

  Timeframe(this.year, this.month);
}

class AppStore {
  late List<CategoryContent> incomeCategories;
  late List<CategoryContent> expenseCategories;
  late Timeframe timeframe;

  AppStore(this.incomeCategories, this.expenseCategories, this.timeframe);

  static AppStore reducer(AppStore state, action) {
    switch (action.type) {
      case AppStoreActions.updateCategoryGoal:
        state.incomeCategories =
            state.incomeCategories.map<CategoryContent>((x) {
          if (x.category.id == action.payload.id) {
            return CategoryContent(
                Category(
                    name: x.category.name,
                    id: x.category.id,
                    type: x.category.type,
                    goal: action.payload.goal),
                x.statements);
          }
          return x;
        }).toList();

        state.expenseCategories =
            state.expenseCategories.map<CategoryContent>((x) {
          if (x.category.id == action.payload.id) {
            return CategoryContent(
                Category(
                    name: x.category.name,
                    id: x.category.id,
                    type: x.category.type,
                    goal: action.payload.goal),
                x.statements);
          }
          return x;
        }).toList();

        Category.updateGoal(
            DB.database!, action.payload.id, action.payload.goal);
        break;
      case AppStoreActions.updateTimeFrame:
        state.timeframe = action.payload;
        break;
      case AppStoreActions.updateCategories:
        var categories = action.payload;
        if (categories.length > 0) {
          state.incomeCategories =
              categories.where((x) => x.category.type == "income").toList();
          state.expenseCategories =
              categories.where((x) => x.category.type == "expense").toList();
        }
        break;
      case AppStoreActions.createCategory:
        String name = action.payload.name;
        String type = action.payload.type;

        var cat = Category(name: name, type: type);

        Category.insert(DB.database!, cat);

        if (action.payload.type == "income") {
          state.incomeCategories
              .add(CategoryContent(Category(name: name, type: type), []));
        } else {
          state.expenseCategories
              .add(CategoryContent(Category(name: name, type: type), []));
        }
        break;
      case AppStoreActions.addStatement:
        var statement = action.payload;

        var now = DateTime.now();
        state.timeframe = Timeframe(now.year, now.month);

        Statement.insert(DB.database!, statement);

        // local
        state.incomeCategories =
            state.incomeCategories.map<CategoryContent>((c) {
          if (c.category.id == statement.categoryId) {
            c.statements.add(statement);
          }

          return c;
        }).toList();

        state.expenseCategories =
            state.expenseCategories.map<CategoryContent>((c) {
          if (c.category.id == statement.categoryId) {
            c.statements.add(statement);
          }

          return c;
        }).toList();

        break;
    }

    return state;
  }
}
