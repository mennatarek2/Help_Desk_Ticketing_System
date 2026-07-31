/// Shared date formatting utilities.
abstract final class DateFormatter {
  static String display(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final month = _months[dateTime.month - 1];
    return '$month ${dateTime.day}, ${dateTime.year} • $hour:$minute $period';
  }

  static String shortDate(DateTime dateTime) {
    final month = _months[dateTime.month - 1];
    return '$month ${dateTime.day}, ${dateTime.year}';
  }

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
