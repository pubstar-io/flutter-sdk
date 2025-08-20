import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_types.dart';

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
    T? listener,
    Future<void> Function(String callbackId) action,
  ) async {
    final callbackId = generateCallbackId();
    
    if (listener != null) {
      _listeners[callbackId] = listener;
    }

    await action(callbackId);
  }
}
