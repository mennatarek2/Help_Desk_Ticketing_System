import '../errors/failures.dart';

/// Resolves a user-friendly message from any error object.
String resolveFailureMessage(
  Object? error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is Failure) {
    return error.message;
  }

  if (error != null) {
    final text = error.toString();
    if (text.isNotEmpty && !text.startsWith('Instance of ')) {
      return text;
    }
  }

  return fallback;
}
