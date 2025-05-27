import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

sealed class PubstarAdEvent {
  final String event;

  PubstarAdEvent({required this.event});

  factory PubstarAdEvent.fromMap(Map map) {
    switch (map['event']) {
      case 'LOADED':
        return AdLoaded(event: map['event'], adId: map['adId']);
      case 'SHOWED':
        return AdShowed(event: map['event'], adId: map['adId']);
      case 'HIDE':
        return AdHide(event: map['event'], adId: map['adId']);
      case 'ERROR':
        return AdError(
          event: map['event'],
          adId: map['adId'],
          error: map['error'],
        );
      default:
        return UnknownEvent(event: map['event'], map: map);
    }
  }

  @override
  String toString() {
    return 'PubstarAdEvent(event: $event)';
  }
}

class AdShowed extends PubstarAdEvent {
  final String adId;
  AdShowed({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdShowed(event: $event, adId: $adId)';
  }
}

class AdHide extends PubstarAdEvent {
  final String adId;
  AdHide({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdHide(event: $event, adId: $adId)';
  }
}

class AdLoaded extends PubstarAdEvent {
  final String adId;
  AdLoaded({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdLoaded(event: $event, adId: $adId)';
  }
}

class AdError extends PubstarAdEvent {
  final String adId;
  final String error;

  AdError({required super.event, required this.adId, required this.error});

  @override
  String toString() {
    return 'AdError(event: $event, adId: $adId, error: $error)';
  }
}

class UnknownEvent extends PubstarAdEvent {
  final Map map;

  UnknownEvent({required super.event, required this.map});

  @override
  String toString() {
    return 'UnknownEvent(event: $event, map: $map)';
  }
}

class PubstarAdEventStream {
  static final _eventChannel = const EventChannel(Constance.eventChannelName);

  static Stream<PubstarAdEvent> get stream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => PubstarAdEvent.fromMap(Map<String, dynamic>.from(event)));
}
