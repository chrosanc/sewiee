import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormat {
  static String formatDateTimeWIB(DateTime date) {
    return "${_two(date.day)} "
        "${_monthName(date.month)} "
        "${date.year}, "
        "${_two(date.hour)}:"
        "${_two(date.minute)} WIB";
  }

  static DateTime? parseFirestoreDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  static String formatDateOnly(DateTime date) {
    return "${_two(date.day)} "
        "${_monthName(date.month)} "
        "${date.year}";
  }

  static String formatTimeOnly(DateTime date) {
    return "${_two(date.hour)}:${_two(date.minute)}";
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return months[month - 1];
  }


}

