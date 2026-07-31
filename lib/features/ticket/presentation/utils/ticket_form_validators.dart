/// Form field validators for ticket screens.
abstract final class TicketFormValidators {
  static String? subject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Subject is required';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }
}
