import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';

import 'pubstar_io_platform_interface.dart';

/// An implementation of [PubstarIoPlatform] that uses method channels.
class MethodChannelPubstarIo extends PubstarIoPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(Constance.methodChannelName);

  @override
  Future<void> init() async {
    try {
      return await methodChannel.invokeMethod('init');
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAd(String adId) async {
    try {
      return await methodChannel.invokeMethod('loadAd', {'adId': adId});
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> showAd({required String adId}) async {
    try {
      await methodChannel.invokeMethod('showAd', {'adId': adId});
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
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
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAndShowAd(adId) async {
    try {
      await methodChannel.invokeMethod('loadAndShowAd', {'adId': adId});
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAndShowAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    try {
      await methodChannel.invokeMethod('loadAndShowAdWithViewId', {
        'adId': adId,
        'viewId': viewId,
      });
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAndShowBannerAd({
    required String adId,
    required int viewId,
    required PubstarAdSize tag,
    required bool isAllowLoadNext,
  }) async {
    try {
      await methodChannel.invokeMethod('loadAndShowBannerAd', {
        'adId': adId,
        'viewId': viewId,
        'tag': tag.name,
        'isAllowLoadNext': isAllowLoadNext,
      });
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAndShowNativeAd({
    required String adId,
    required int viewId,
    required PubstarAdSize typeSize,
    required bool isAllowLoadNext,
  }) async {
    try {
      await methodChannel.invokeMethod('loadAndShowNativeAd', {
        'adId': adId,
        'viewId': viewId,
        'typeSize': typeSize.name,
        'isAllowLoadNext': isAllowLoadNext,
      });
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }

  @override
  Future<void> loadAndShowVideoAd({
    required String adId,
    required int viewId,
    required String media,
  }) async {
    try {
      await methodChannel.invokeMethod('loadAndShowVideoAd', {
        'adId': adId,
        'viewId': viewId,
        'media': media,
      });
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }
}
