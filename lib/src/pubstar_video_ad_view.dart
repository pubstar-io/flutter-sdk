import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_core.dart';

class PubstarVideoAdView extends StatelessWidget {
  /// A Flutter widget for displaying a video ad view using Pubstar IO plugin.
  ///
  /// This widget embeds a native Android or iOS view (via [AndroidView | UIView]) to render
  /// an ad, and automatically triggers the `loadAndShowVideoAd` call when the
  /// platform view is created.
  ///
  /// Example usage:
  /// ```dart
  /// PubstarVideoAdView(adId: 'your_ad_id')
  /// ```
  ///
  /// __Usage notes:__
  /// - You must call `PubstarIo.instance.init()` before using this widget.
  /// - The [adId] parameter must be a valid ad unit ID from your ad provider.
  /// - Place this widget inside your widget tree where you want the ad to appear.
  /// - Handles lifecycle and automatically calls `loadAndShowVideoAd`.
  const PubstarVideoAdView({
    super.key,
    required this.adId,
    required this.media,
  });

  /// The ad ID to be loaded and displayed in this view.
  ///
  /// You should use the ad ID provided by your ad network or backend.
  final String adId;

  /// The video is displayed in this view.
  ///
  /// This should be a URL string as required.
  final String media;

  onPlatformViewCreated(int viewId) {
    PubstarIo.instance.loadAndShowVideoAd(
      adId: adId,
      viewId: viewId,
      media: media,
    );
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = Constance.viewType;

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onPlatformViewCreated,
      );
    }

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onPlatformViewCreated,
      );
    }

    throw UnsupportedError('Unsupported platform view');
  }
}
