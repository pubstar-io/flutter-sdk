import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';

import 'pubstar_io_platform_interface.dart';

enum PubstarAdEvent { loaded, showed, hide, error, done }

class PubstarError {
  final String code;
  final int? rawCode;
  const PubstarError({required this.code, this.rawCode});
}

typedef OnLoaded = void Function();
typedef OnLoadedError = void Function();
typedef OnShowed = void Function();
typedef OnShowedError = void Function();
typedef OnHide = void Function();
typedef OnError = void Function(PubstarError error);
typedef OnDone = void Function();
typedef OnInit = void Function();

sealed class PubstarListener {}

class InitListener extends PubstarListener {
  final OnInit? onInit;
  final OnError? onError;
  InitListener({this.onInit, this.onError});
}

class LoadListener extends PubstarListener {
  final OnLoaded? onLoaded;
  final OnError? onError;
  LoadListener({this.onLoaded, this.onError});
}

class ShowListener extends PubstarListener {
  final OnHide? onHide;
  final OnShowed? onShowed;
  final OnError? onError;
  ShowListener({this.onHide, this.onShowed, this.onError});
}

class LoadAndShowListener extends PubstarListener {
  final OnLoaded? onLoaded;
  final OnError? onError;
  final OnHide? onHide;
  final OnShowed? onShowed;

  LoadAndShowListener({
    this.onLoaded,
    this.onError,
    this.onHide,
    this.onShowed,
  });
}

class CallbackHandler {
  static bool _bound = false;
  static final Map<String, PubstarListener> _listeners = {};

  static String generateCallbackId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  static void bind(MethodChannel channel) {
    if (_bound) return;
    _bound = true;
    channel.setMethodCallHandler(_handleNativeCallback);
  }

  static Future<void> _handleNativeCallback(MethodCall call) async {
    if (call.method != 'pubstar_io#callback') return;

    final map = Map<String, dynamic>.from(call.arguments as Map);
    final String event = (map['event'] as String?) ?? '';
    final String? cbId = map['cbId'] as String?;

    print("FLUTTER: Callback received - event: $event - cbId: $cbId");

    if (cbId == null) return;

    final listener = _listeners[cbId];
    if (listener == null) return;

    if (listener is InitListener) {
      _handleInitListener(listener, event, map);
    } else if (listener is LoadAndShowListener) {
      _handleLoadAndShowListener(listener, event, map);
    }
  }

  static void _handleInitListener(
    InitListener listener,
    String event,
    Map<String, dynamic> map,
  ) {
    switch (event) {
      case 'INIT':
        listener.onInit?.call();
        break;
      case 'ERROR':
        listener.onError?.call(
          PubstarError(code: (map['error'] as String?) ?? 'UNKNOWN'),
        );
        break;
    }
  }

  static void _handleLoadAndShowListener(
    LoadAndShowListener listener,
    String event,
    Map<String, dynamic> map,
  ) {
    switch (event) {
      case 'LOADED':
        listener.onLoaded?.call();
        break;
      case 'SHOWED':
        listener.onShowed?.call();
        break;
      case 'HIDE':
        listener.onHide?.call();
        break;
      case 'ERROR':
        listener.onError?.call(
          PubstarError(
            code: (map['error'] as String?) ?? 'UNKNOWN',
            rawCode: (map['code'] as num?)?.toInt(),
          ),
        );
        break;
    }
  }

  static Future<void> withCallbackListener<T extends PubstarListener>(
    T listener,
    Future<void> Function(String callbackId) action,
  ) async {
    final callbackId = generateCallbackId();
    _listeners[callbackId] = listener;

    try {
      await action(callbackId);
    } finally {
      _listeners.remove(callbackId);
    }
  }
}

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
