import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

/// The available types for displaying PubstarAdView.
///
/// - [onlyShow]: only show ad when view be loaded. You must call `PubstarIo.instance.loadAd` before using this.
/// - [loadAndShow]: load ad first, then show when ready.
enum PubstarAdViewMode {
  /// Only show ad when the view is loaded.
  ///
  /// You must call `PubstarIo.instance.loadAd` before using this.
  onlyShow,

  /// Load ad first, then show when ready.
  loadAndShow,
}

/// The type of ad to be displayed in the PubstarAdView.
///
/// - [banner]: Display a banner ad.
/// - [native]: Display a native ad.
enum PubstarAdType { banner, native }

/// The size of ad view
enum PubstarAdSize {
  /// Set small size for ad view
  small,

  /// Set medium size for ad view
  medium,

  /// Set big size for ad view
  big,

  /// Only available for banner ad.
  collapsible,
}

class PubstarAdView extends StatelessWidget {
  /// A Flutter widget for displaying a native ad view using Pubstar IO plugin.
  ///
  /// This widget embeds a native Android view (via [AndroidView]) to render
  /// an ad, and automatically triggers the `showAdWithViewId` call when the
  /// platform view is created.
  ///
  /// Example usage:
  /// ```dart
  /// PubstarAdView(adId: 'your_ad_id')
  /// PubstarAdView(adId: 'your_ad_id', mode: PubstarAdViewMode.onlyShow)
  /// ```
  ///
  /// __Usage notes:__
  /// - You must call `PubstarIo.instance.init()` before using this widget.
  /// - The [adId] parameter must be a valid ad unit ID from your ad provider.
  /// - Place this widget inside your widget tree where you want the ad to appear.
  /// - Handles lifecycle and automatically calls `showAdWithViewId`.
  const PubstarAdView({
    super.key,
    required this.adId,
    this.type,
    this.mode = PubstarAdViewMode.loadAndShow,
    this.size,
    this.onError,
    this.onLoaded,
    this.onHide,
    this.onShowed,
  });

  /// The ad ID to be loaded and displayed in this view.
  ///
  /// You should use the ad ID provided by your ad network or backend.
  final String adId;

  /// The mode for displaying the ad in this view.
  ///
  /// - [PubstarAdViewMode.onlyShow]: Only show the ad when the view is loaded.
  /// - [PubstarAdViewMode.loadAndShow]: Load the ad first, then show it when ready.
  final PubstarAdViewMode mode;

  /// The type for displaying the ad in this view.
  ///
  /// If you want to use a specific type and more control (eg: custom size), you must set it.
  /// - [PubstarAdType.banner]: Display a banner ad.
  /// - [PubstarAdType.native]: Display a native ad.
  ///
  /// If null, the ad will be loaded and shown without a specific type.
  /// If you want to use a specific type, you must set it.
  final PubstarAdType? type;

  /// The Size for set size of banner and native ad view.
  ///
  /// If you want to use a specific type size, you must set it.
  /// - [PubstarAdSize.small]: Small size for native ad.
  /// - [PubstarAdSize.medium]: Medium size for native ad.
  /// - [PubstarAdSize.big]: Big size for native ad.
  /// - [PubstarAdSize.collapsible]: **Only** available of Banner ad view. Full size for native ad.
  /// If null, the default size will be used. Default is [PubstarAdSize.small].
  final PubstarAdSize? size;

  /// Called when an error occurs during the ad lifecycle.
  ///
  /// This callback will provide a [PubstarError] object containing
  /// error details such as code, name, and message.
  /// 
  /// Example:
  /// ```dart
  /// PubstarAdView(
  ///   adId: 'your_ad_id',
  ///   onError: (error) {
  ///     print("Ad failed with code: ${error.code}, message: ${error.message}");
  ///   },
  /// )
  /// ```
  final OnError? onError;

  /// Called when the ad has been successfully loaded.
  ///
  /// Use this callback to know when the ad content is ready to be displayed.
  ///
  /// Example:
  /// ```dart
  /// PubstarAdView(
  ///   adId: 'your_ad_id',
  ///   onLoaded: () {
  ///     print("Ad loaded successfully!");
  ///   },
  /// )
  /// ```
  final OnLoaded? onLoaded;

  /// Called when the ad is hidden or closed by the user.
  ///
  /// For rewarded ads, this callback may also return a reward object
  /// containing the reward type and amount if applicable.
  ///
  /// Example:
  /// ```dart
  /// PubstarAdView(
  ///   adId: 'your_ad_id',
  ///   onHide: (reward) {
  ///     print("Ad was closed by the user");
  ///   },
  /// )
  /// ```
  final OnHide? onHide;

  /// Called when the ad is shown to the user.
  ///
  /// Use this callback to track impressions or log analytics
  /// when the ad becomes visible on the screen.
  ///
  /// Example:
  /// ```dart
  /// PubstarAdView(
  ///   adId: 'your_ad_id',
  ///   onShowed: () {
  ///     print("Ad is now visible to the user");
  ///   },
  /// )
  /// ```
  final OnShowed? onShowed;

  onPlatformViewCreated(int viewId) {
    if (type != null) {
      final PubstarAdSize sizeValue = size ?? PubstarAdSize.small;

      switch (type!) {
        case PubstarAdType.banner:
          PubstarIo.loadAndShowBannerAd(
            adId: adId,
            viewId: viewId,
            size: sizeValue,
            listener: LoadAndShowListener(
              onError: onError,
              onHide: onHide,
              onLoaded: onLoaded,
              onShowed: onShowed,
            ),
          );
          break;
        case PubstarAdType.native:
          PubstarIo.loadAndShowNativeAd(
            adId: adId,
            viewId: viewId,
            size: sizeValue,
            listener: LoadAndShowListener(
              onError: onError,
              onHide: onHide,
              onLoaded: onLoaded,
              onShowed: onShowed,
            ),
          );
          break;
      }

      return;
    }

    if (mode == PubstarAdViewMode.onlyShow) {
      PubstarIo.showAdWithViewId(
        adId: adId,
        viewId: viewId,
        listener: ShowListener(
          onError: onError,
          onHide: onHide,
          onShowed: onShowed,
        ),
      );
      return;
    }

    PubstarIo.loadAndShowAdWithViewId(
      adId: adId,
      viewId: viewId,
      listener: LoadAndShowListener(
        onError: onError,
        onHide: onHide,
        onLoaded: onLoaded,
        onShowed: onShowed,
      ),
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
