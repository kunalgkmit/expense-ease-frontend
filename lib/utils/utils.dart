import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  NumberFormat numberFormat = NumberFormat.currency(
    symbol: '₹',
    name: "INR",
    locale: 'en_IN',
  );
  return numberFormat.format(amount);
}
