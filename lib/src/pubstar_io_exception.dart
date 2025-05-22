import 'package:pubstar_io/src/error_code.dart';

class PubstarIoException implements Exception {
  final ErrorCode errorCode;
  final String? message;

  PubstarIoException(this.errorCode, [this.message]);

  @override
  String toString() => 'PubstarIoException($errorCode): $message';
}
