import 'package:intl/intl.dart';

String formatDateString(String dateString, String formatPreference) {
  try {
    final inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat;

    if (formatPreference == "DD.MM.YYYY") {
      outputFormat = DateFormat('dd.MM.yyyy');
    } else if (formatPreference == "MM.DD.YYYY") {
      outputFormat = DateFormat('MM.dd.yyyy');
    } else {
      outputFormat = DateFormat('dd.MM.yyyy');
    }

    final date = inputFormat.parse(dateString);
    final formattedDate = outputFormat.format(date);

    return formattedDate;
  } catch (e) {
    return dateString;
  }
}