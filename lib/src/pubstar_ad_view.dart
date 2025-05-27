import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_core.dart';

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
  /// PubstarAdView(adId: 'your_ad_id', mode: PubstarAdViewMode.loadAndShow)
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
    this.mode = PubstarAdViewMode.onlyShow,
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

  Widget build(BuildContext context) {
    const String viewType = Constance.viewType;

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int viewId) {
        if (mode == PubstarAdViewMode.onlyShow) {
          PubstarIo.instance.showAdWithViewId(adId: adId, viewId: viewId);
          return;
        }

        PubstarIo.instance.loadAndShowAdWithViewId(adId: adId, viewId: viewId);
      },
    );
  }
}
