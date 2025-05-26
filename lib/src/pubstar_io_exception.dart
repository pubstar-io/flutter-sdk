import 'package:pubstar_io/src/error_code.dart';

class PubstarIoException implements Exception {
  final ErrorCode errorCode;
  final String? message;
  final String? details;

  PubstarIoException({
    required this.errorCode,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'PubstarIoException($errorCode): $message - $details';
}
