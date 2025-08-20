import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/callback_handler.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';
import 'package:pubstar_io/src/pubstar_types.dart';

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
  Future<void> loadAd(String adId, [LoadListener? listener]) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
  Future<void> showAd(String adId, [ShowListener? listener]) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
    ShowListener? listener,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
  Future<void> loadAndShowAd(adId, [LoadAndShowListener? listener]) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
    LoadAndShowListener? listener,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
    LoadAndShowListener? listener,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
    LoadAndShowListener? listener,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
    LoadAndShowListener? listener,
  }) async {
    try {
      await CallbackHandler.withCallbackListener(
        listener,
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
