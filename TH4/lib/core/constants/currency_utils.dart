import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _vietnamFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  static String formatVND(double amount) {
    return _vietnamFormat.format(amount);
  }
}
