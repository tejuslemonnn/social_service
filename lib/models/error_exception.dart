class ErrorException extends Error {
  final String message;

  ErrorException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}
