import 'package:currency_formatter/currency_formatter.dart';

class CurrencyUtils {

  String currencyFormat(int amount) {
    String inLocaleCurrency =
    CurrencyFormatter.format(amount, CurrencyFormat.fromLocale('id_ID')!);
    return inLocaleCurrency;
  }
}


