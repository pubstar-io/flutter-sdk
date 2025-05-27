import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

class PubstarAdEventStream {
  static final _eventChannel = const EventChannel(Constance.eventChannelName);

  static Stream<Map<dynamic, dynamic>> get stream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event as Map<dynamic, dynamic>);
}
