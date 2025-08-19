import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/callback_handler.dart';
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
      CallbackHandler.bind(methodChannel);

      await CallbackHandler.withCallbackListener(
        InitListener(
          onInit: () => print("FLUTTER - sdk: init"),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('init', {"callbackId": cbId}),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadListener(
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('loadAd', {'callbackId': adId}),
      );
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
      await CallbackHandler.withCallbackListener(
        ShowListener(
          onShowed: () => print("FLUTTER - sdk: onShowed"),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('showAd', {
          'adId': adId,
          'callbackId': adId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        ShowListener(
          onShowed: () => print("FLUTTER - sdk: onShowed"),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('showAdWithViewId', {
          'adId': adId,
          "viewId": viewId,
          "callbackId": cbId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onShowed: () => print("FLUTTER - sdk: onShowed"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowAd', {
          'adId': adId,
          'callbackId': cbId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onShowed: () => print("FLUTTER - sdk: onShowed"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowAdWithViewId', {
          'adId': adId,
          'viewId': viewId,
          'callbackId': cbId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onShowed: () => print("FLUTTER - sdk: onShowed"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowBannerAd', {
          'adId': adId,
          'viewId': viewId,
          'tag': tag.name,
          'isAllowLoadNext': isAllowLoadNext,
          'callbackId': cbId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onShowed: () => print("FLUTTER - sdk: onShowed"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowNativeAd', {
          'adId': adId,
          'viewId': viewId,
          'typeSize': typeSize.name,
          'isAllowLoadNext': isAllowLoadNext,
          'callbackId': cbId,
        }),
      );
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
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.rawCode}",
              ),
          onHide: () => print("FLUTTER - sdk: onHide"),
          onLoaded: () => print("FLUTTER - sdk: onLoaded"),
          onShowed: () => print("FLUTTER - sdk: onShowed"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowVideoAd', {
          'adId': adId,
          'viewId': viewId,
          'media': media,
          'callbackId': cbId,
        }),
      );
    } on PlatformException catch (e) {
      throw PubstarIoException(
        errorCode: ErrorCodeUtil.errorCodeFromNative(e.code),
        message: e.message.toString(),
        details: e.details.toString(),
      );
    }
  }
}
