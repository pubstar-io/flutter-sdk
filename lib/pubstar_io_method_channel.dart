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
  Future<void> init() async {
    try {
      return await methodChannel.invokeMethod('init');
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<void> loadAd(String adId) async {
    try {
      return await methodChannel.invokeMethod('loadAd', {'adId': adId});
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<void> showAd({required String adId}) async {
    try {
      await methodChannel.invokeMethod('showAd', {'adId': adId});
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<void> showAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    try {
      await methodChannel.invokeMethod('showAdWithViewId', {
        'adId': adId,
        "viewId": viewId,
      });
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }

  @override
  Future<void> loadAndShowAd({
    required String adId,
    required int viewId,
  }) async {
    try {
      await methodChannel.invokeMethod('loadAndShowAd', {
        'adId': adId,
        "viewId": viewId,
      });
    } on PlatformException catch (e) {
      final errorCode = ErrorCodeUtil.errorCodeFromNative(e.message ?? '');
      throw PubstarIoException(errorCode, e.details?.toString() ?? e.message);
    }
  }
}
