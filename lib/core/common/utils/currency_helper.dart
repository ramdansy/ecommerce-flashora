import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyHelper {
  static final formatter = NumberFormat("#,##0", "id_ID");

  static String formatCurrency(int value) {
    return 'Rp${formatter.format(value)}';
  }

  static String formatCurrencyDouble(double value) {
    return 'Rp${formatter.format(value)}';
  }

  static String reformatCurrency(String value) {
    return value.replaceAll('.', '').replaceAll('Rp', '');
  }

  static String thousandFormatCurrency(String value) {
    var replaceStr = value.contains(",")
        ? value.replaceAll(",", "")
        : value.replaceAll(".", "");
    var formatToNumber = int.parse(replaceStr);
    return formatter.format(formatToNumber);
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int value = int.parse(newValue.text.replaceAll(',', ''));

    final formatter = NumberFormat('#,###');

    final newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
