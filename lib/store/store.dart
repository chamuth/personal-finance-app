import 'model.dart';

class CategoryContent
{
  final Category category;
  final Statement statements;

  CategoryContent(this.category, this.statements);
}


class AppStore {
  late List<CategoryContent> incomeCategories;
  late List<CategoryContent> expenseCategories;

  AppStore(this.incomeCategories, this.expenseCategories);

  static AppStore reducer(AppStore previous, action) {
    return previous;
  }
}