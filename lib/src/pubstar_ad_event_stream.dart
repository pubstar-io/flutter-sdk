import 'package:flutter/services.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

/// Defines all possible ad events emitted by the Pubstar IO Ads plugin.
///
/// The [PubstarAdEvent] sealed class (and its subclasses) represent
/// structured ad event types received from the native layer via [PubstarAdEventStream].
///
/// Usage example:
/// ```dart
/// PubstarAdEventStream.stream.listen((event) {
///   switch (event) {
///     case AdLoaded():
///       // Handle ad loaded
///       break;
///     case AdShowed():
///       // Handle ad shown
///       break;
///     case AdHide():
///       // Handle ad hidden/closed
///       break;
///     case AdError():
///       // Handle ad error
///       break;
///     case UnknownEvent():
///       // Handle unknown/custom event
///       break;
///   }
/// });
/// ```
sealed class PubstarAdEvent {
  final String event;

  /// Constructs a [PubstarAdEvent] with the given [event] type.
  PubstarAdEvent({required this.event});

  /// Factory constructor to parse a [Map] (typically from EventChannel)
  /// into the appropriate [PubstarAdEvent] subclass.
  ///
  /// Supports events: `LOADED`, `SHOWED`, `HIDE`, `ERROR`.
  /// If event type is unknown, returns [UnknownEvent].
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

/// Event emitted when an ad is successfully shown.
///
/// Contains the ad unit ID ([adId]) associated with the event.
class AdShowed extends PubstarAdEvent {
  final String adId;
  AdShowed({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdShowed(event: $event, adId: $adId)';
  }
}


/// Event emitted when an ad is hidden, dismissed, or closed.
///
/// Contains the ad unit ID ([adId]) associated with the event.
class AdHide extends PubstarAdEvent {
  final String adId;
  AdHide({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdHide(event: $event, adId: $adId)';
  }
}


/// Event emitted when an ad is successfully loaded and ready to be shown.
///
/// Contains the ad unit ID ([adId]) associated with the event.
class AdLoaded extends PubstarAdEvent {
  final String adId;
  AdLoaded({required super.event, required this.adId});

  @override
  String toString() {
    return 'AdLoaded(event: $event, adId: $adId)';
  }
}


/// Event emitted when there is an error loading or showing an ad.
///
/// Contains the ad unit ID ([adId]) and an error message ([error]).
class AdError extends PubstarAdEvent {
  final String adId;
  final String error;

  AdError({required super.event, required this.adId, required this.error});

  @override
  String toString() {
    return 'AdError(event: $event, adId: $adId, error: $error)';
  }
}


/// Event emitted when an unknown or unhandled event type is received from native.
///
/// Contains the raw [map] of event data.
class UnknownEvent extends PubstarAdEvent {
  final Map map;

  UnknownEvent({required super.event, required this.map});

  @override
  String toString() {
    return 'UnknownEvent(event: $event, map: $map)';
  }
}

/// Stream for receiving ad events from native code via EventChannel.
///
/// Listens to the underlying EventChannel and parses each event as a [PubstarAdEvent].
///
/// Example usage:
/// ```dart
/// PubstarAdEventStream.stream.listen((event) {
///   switch (event) {
///     case AdLoaded():
///       // Handle ad loaded
///       break;
///     case AdShowed():
///       // Handle ad shown
///       break;
///     case AdHide():
///       // Handle ad hidden/closed
///       break;
///     case AdError():
///       // Handle ad error
///       break;
///     case UnknownEvent():
///       // Handle unknown/custom event
///       break;
///   }
/// });
/// ```
class PubstarAdEventStream {
  static final _eventChannel = const EventChannel(Constance.eventChannelName);

  static Stream<PubstarAdEvent> get stream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => PubstarAdEvent.fromMap(Map<String, dynamic>.from(event)));
}
