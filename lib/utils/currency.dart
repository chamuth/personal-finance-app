import 'package:intl/intl.dart';

class Currency
{
  static final cf = NumberFormat("#,##0.00", "en_US");
  static final cf2 = NumberFormat("#,##0", "en_US");

  static String format(double amount, {bool cents = true})
  {
    return (cents == true ? cf : cf2).format(amount);
  }

  static String truncateDigits(double n){
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
