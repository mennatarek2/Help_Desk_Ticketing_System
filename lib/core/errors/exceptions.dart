/// Thrown when local storage operations fail.
class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;

  @override
  String toString() => message ?? 'A local storage error occurred.';
}
