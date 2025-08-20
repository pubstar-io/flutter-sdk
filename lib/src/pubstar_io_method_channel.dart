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

      await methodChannel.invokeMethod('init');
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
          onLoaded: () => print("FLUTTER - sdk: onLoaded loadAd"),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('loadAd', {
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
  Future<void> showAd(String adId) async {
    try {
      await CallbackHandler.withCallbackListener(
        ShowListener(
          onShowed: () => print("FLUTTER - sdk: onShowed showAd"),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide showAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError showAd, code: ${error.code} - name: ${error.name} - message: ${error.message}",
              ),
        ),
        (cbId) => methodChannel.invokeMethod('showAd', {
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
  Future<void> showAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        ShowListener(
          onShowed: () => print("FLUTTER - sdk: onShowed showAdWithViewId"),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide showAdWithViewId - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
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
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide loadAndShowAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onLoaded: () => print("FLUTTER - sdk: onLoaded loadAndShowAd"),
          onShowed: () => print("FLUTTER - sdk: onShowed loadAndShowAd"),
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
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide loadAndShowAdWithViewId  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onLoaded:
              () => print("FLUTTER - sdk: onLoaded loadAndShowAdWithViewId"),
          onShowed:
              () => print("FLUTTER - sdk: onShowed loadAndShowAdWithViewId"),
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
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide loadAndShowBannerAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onLoaded: () => print("FLUTTER - sdk: onLoaded loadAndShowBannerAd"),
          onShowed: () => print("FLUTTER - sdk: onShowed loadAndShowBannerAd"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowBannerAd', {
          'adId': adId,
          'viewId': viewId,
          'tag': tag.name,
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
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        LoadAndShowListener(
          onError:
              (error) => print(
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide loadAndShowNativeAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
              ),
          onLoaded: () => print("FLUTTER - sdk: onLoaded loadAndShowNativeAd"),
          onShowed: () => print("FLUTTER - sdk: onShowed loadAndShowNativeAd"),
        ),
        (cbId) => methodChannel.invokeMethod('loadAndShowNativeAd', {
          'adId': adId,
          'viewId': viewId,
          'typeSize': typeSize.name,
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
                "FLUTTER - sdk: onError, code: ${error.code} - rawCode: ${error.name}",
              ),
          onHide:
              (reward) => print(
                "FLUTTER - sdk: onHide loadAndShowVideoAd  - type: ${reward?.type} - amount: ${reward?.amount}",
              ),
          onLoaded: () => print("FLUTTER - sdk: onLoaded loadAndShowVideoAd"),
          onShowed: () => print("FLUTTER - sdk: onShowed loadAndShowVideoAd"),
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
