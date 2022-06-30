class MonthUtils {
  static int serialize(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static List<int> getBetween(int year, int month) {
    var start = DateTime(year, month, 1);
    var end = DateTime(year, month + 1, 1, 0, 0, 0);

    return [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch];
  }
}
