import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

class PubstarEventService {
  static final PubstarEventService _instance = PubstarEventService._internal();

  factory PubstarEventService() => _instance;

  PubstarEventService._internal();

  static const _eventChannel = EventChannel(Constance.eventChannelName);

  Stream<dynamic>? _internalStream;

  StreamSubscription<dynamic> listen(void Function(dynamic event) onData) {
    _internalStream ??= _eventChannel.receiveBroadcastStream();
    return _internalStream!.listen(onData);
  }
}
