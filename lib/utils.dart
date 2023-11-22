import 'package:intl/intl.dart';

class Utils {
  static bool validateEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static String getFormatDate(DateTime dateTime,
      {String formatValue = 'yyy-MM-dd'}) {
    final format = DateFormat(formatValue);
    return format.format(dateTime);
  }
}
