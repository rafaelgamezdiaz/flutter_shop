class WrongCredentials implements Exception {
  WrongCredentials();

  @override
  String toString() {
    return 'Credenciales inválidas';
  }
}

class InvalidToken implements Exception {
  final String message;

  InvalidToken(this.message);

  @override
  String toString() {
    return 'InvalidToken: $message';
  }
}

class ConnectionTimeout implements Exception {
  final String message;

  ConnectionTimeout(this.message);

  @override
  String toString() {
    return 'ConnectionTimeout: $message';
  }
}

class CustomError implements Exception {
  final String message;
  final int statusCode;
  final bool loggedRequired;

  CustomError(this.message, this.statusCode, [this.loggedRequired = false]);

  // Idea a implementar, si loggedRequired es true, entonces podemos guardar el error en Log

  @override
  String toString() {
    return 'CustomError: $message';
  }
}
