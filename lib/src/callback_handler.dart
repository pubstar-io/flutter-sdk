import 'package:flutter/services.dart';

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
