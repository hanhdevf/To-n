/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Exception when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(String message, {this.statusCode}) : super(message);
}

/// Exception when local cache operation fails
class CacheException extends AppException {
  const CacheException([String message = 'Cache exception']) : super(message);
}

/// Exception when network connection is unavailable
class NetworkException extends AppException {
  const NetworkException([String message = 'Network exception'])
    : super(message);
}

/// Exception when authentication fails
class AuthException extends AppException {
  const AuthException([String message = 'Authentication exception'])
    : super(message);
}

/// Exception when resource is not found
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found'])
    : super(message);
}
