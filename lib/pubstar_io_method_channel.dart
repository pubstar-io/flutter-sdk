import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubstar_io/src/error_code.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';

import 'pubstar_io_platform_interface.dart';

/// An implementation of [PubstarIoPlatform] that uses method channels.
class MethodChannelPubstarIo extends PubstarIoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pubstar_io');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool?> init() async {
    try {
      return await methodChannel.invokeMethod('init');
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<bool?> loadAd(String adId) async {
    try {
      return await methodChannel.invokeMethod('loadAd', {'adId': adId});
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<String?> showAd({required String adId, int? viewId}) async {
    try {
      var result = await methodChannel.invokeMethod('showAd', {
        'adId': adId,
        'viewId': viewId,
      });
      print("showAd success: $result");
      return result;
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      print("showAd error: $errorCode -${e.message}");
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }
}
