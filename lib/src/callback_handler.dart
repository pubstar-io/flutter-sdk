import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

enum PubstarAdEvent { loaded, showed, hide, error, done }

class PubstarError {
  final int? code;
  final String? name;
  final String? message;
  const PubstarError({this.code, this.name, this.message});

  static PubstarError fromMap(Map<String, dynamic> map) {
    return PubstarError(
      code: (map['code'] as int).toInt(),
      name: map['name'] as String,
      message: map['message'] as String,
    );
  }
}

class PubstarReward {
  final String? type;
  final int? amount;
  const PubstarReward({this.type, this.amount});

  static PubstarReward? fromMap(Map<String, dynamic> map) {
    if (map.containsKey('type') && map.containsKey('amount')) {
      return PubstarReward(
        type: map['type'] as String,
        amount: (map['amount'] as int).toInt(),
      );
    }

    return null;
  }
}

typedef OnLoaded = void Function();
typedef OnLoadedError = void Function();
typedef OnShowed = void Function();
typedef OnShowedError = void Function();
typedef OnHide = void Function(PubstarReward? reward);
typedef OnError = void Function(PubstarError error);
typedef OnDone = void Function();
typedef OnInit = void Function();

sealed class PubstarListener {
  final OnError? onError;
  const PubstarListener({this.onError});

  bool shouldRemove(String event);
}

class InitListener extends PubstarListener {
  final OnInit? onInit;
  InitListener({this.onInit, super.onError});

  @override
  bool shouldRemove(String event) => event == 'INIT' || event == 'ERROR';
}

class LoadListener extends PubstarListener {
  final OnLoaded? onLoaded;
  LoadListener({this.onLoaded, super.onError});

  @override
  bool shouldRemove(String event) => event == 'LOADED' || event == 'ERROR';
}

class ShowListener extends PubstarListener {
  final OnHide? onHide;
  final OnShowed? onShowed;
  ShowListener({this.onHide, this.onShowed, super.onError});

  @override
  bool shouldRemove(String event) => event == 'HIDE' || event == 'ERROR';
}

class LoadAndShowListener extends PubstarListener {
  final OnLoaded? onLoaded;
  final OnHide? onHide;
  final OnShowed? onShowed;

  LoadAndShowListener({
    this.onLoaded,
    super.onError,
    this.onHide,
    this.onShowed,
  });

  @override
  bool shouldRemove(String event) => event == 'HIDE' || event == 'ERROR';
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
    print(
      "FLUTTER - sdk: _handleNativeCallback called - call.method: ${call.method}",
    );
    if (call.method != Constance.methodChannelCallback) return;

    final map = Map<String, dynamic>.from(call.arguments as Map);
    final String event = (map['event'] as String?) ?? '';
    final String? cbId = map['cbId'] as String?;

    print("FLUTTER - sdk: _listeners: ${_listeners.keys.toList()}");
    print("FLUTTER - sdk: event: $event - cbId: $cbId");

    if (cbId == null) return;

    final listener = _listeners[cbId];
    if (listener == null) return;

    print("FLUTTER - sdk: Type of listener: ${listener.runtimeType}");

    if (listener is InitListener) {
      handleInitListener(listener, event, map);
    } else if (listener is LoadListener) {
      handleLoadListener(listener, event, map);
    } else if (listener is ShowListener) {
      handleShowListener(listener, event, map);
    } else if (listener is LoadAndShowListener) {
      handleLoadAndShowListener(listener, event, map);
    }

    print(
      "FLUTTER - sdk: listener.shouldRemove: ${listener.shouldRemove(event)}",
    );
    if (listener.shouldRemove(event)) {
      print("FLUTTER - sdk: listener $cbId has been removed");
      _listeners.remove(cbId);
    }
  }

  static void handleInitListener(
    InitListener listener,
    String event,
    Map<String, dynamic> map,
  ) {
    switch (event) {
      case 'INIT':
        listener.onInit?.call();
        break;
      case 'ERROR':
        listener.onError?.call(PubstarError.fromMap(map));
        break;
    }
  }

  static void handleLoadListener(
    LoadListener listener,
    String event,
    Map<String, dynamic> map,
  ) {
    switch (event) {
      case 'LOADED':
        listener.onLoaded?.call();
        break;
      case 'ERROR':
        listener.onError?.call(PubstarError.fromMap(map));
        break;
    }
  }

  static void handleShowListener(
    ShowListener listener,
    String event,
    Map<String, dynamic> map,
  ) {
    switch (event) {
      case 'SHOWED':
        listener.onShowed?.call();
        break;
      case 'HIDE':
        listener.onHide?.call(PubstarReward.fromMap(map));
        break;
      case 'ERROR':
        listener.onError?.call(PubstarError.fromMap(map));
        break;
    }
  }

  static void handleLoadAndShowListener(
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
        listener.onHide?.call(PubstarReward.fromMap(map));
        break;
      case 'ERROR':
        listener.onError?.call(PubstarError.fromMap(map));
        break;
    }
  }

  static Future<void> withCallbackListener<T extends PubstarListener>(
    T listener,
    Future<void> Function(String callbackId) action,
  ) async {
    final callbackId = generateCallbackId();
    _listeners[callbackId] = listener;

    await action(callbackId);
  }
}
