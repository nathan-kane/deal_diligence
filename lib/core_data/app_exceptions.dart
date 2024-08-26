import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final String? message;

  final dynamic prefix;

  const AppException([this.message, this.prefix]);

  @override
  String toString() {
    return '$message$prefix';
  }

  @override
  List<Object?> get props => [message, prefix];
}

class FetchDataException extends AppException {
  const FetchDataException([String? message])
      : super(message, 'Error During Communication');
}

class InternalServerException extends AppException {
  const InternalServerException([String? message, dynamic status])
      : super(
          message,
          'Internal server error [500]',
        );
}

class BadRequestException extends AppException {
  const BadRequestException([String? message])
      : super(message, 'Invalid request [400]');
}

class UnauthorisedException extends AppException {
  const UnauthorisedException([String? message])
      : super(message, 'Unauthorised request [404]');
}

class InvalidInputException extends AppException {
  const InvalidInputException([String? message])
      : super(message, 'Invalid Input');
}

class NoInternetException extends AppException {
  const NoInternetException([String? message])
      : super(message, 'Communication issue');
}

class APIException extends Equatable implements Exception {
  const APIException({required this.message, required this.statusCode});
  final String message;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});
  final String message;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException extends Equatable implements Exception {
  const CacheException({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
