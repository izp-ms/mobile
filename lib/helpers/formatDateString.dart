import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  try {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd.MM.yyyy');

    final date = inputFormat.parse(dateString);
    final formattedDate = outputFormat.format(date);

    return formattedDate;
  } catch (e) {
    return dateString;
  }
}