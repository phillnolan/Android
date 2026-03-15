import 'package:intl/intl.dart';

class CurrencyUtils {
  static const double usdToVndRate = 25000;

  static final NumberFormat _vietnamFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  static String formatVND(double amount) {
    return _vietnamFormat.format(amount);
  }

  static String formatUSDtoVND(double usdAmount) {
    return _vietnamFormat.format(usdAmount * usdToVndRate);
  }
}
