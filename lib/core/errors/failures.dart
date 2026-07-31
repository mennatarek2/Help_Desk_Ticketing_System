/// Base class for domain-level failures.
abstract class Failure {
  const Failure(this.message);

  final String message;
}

/// Failure returned when local storage operations fail.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Unable to access local storage.']);
}

/// Failure returned when a requested ticket cannot be found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Ticket not found.']);
}

/// Failure returned when ticket data fails validation.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
