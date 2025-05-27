import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_core.dart';

/// A Flutter widget for displaying a native ad view using Pubstar IO plugin.
///
/// This widget embeds a native Android view (via [AndroidView]) to render
/// an ad, and automatically triggers the `showAdWithViewId` call when the
/// platform view is created.
///
/// Example usage:
/// ```dart
/// PubstarAdView(adId: 'your_ad_id')
/// ```
///
/// __Usage notes:__
/// - You must call `PubstarIo.instance.init()` before using this widget.
/// - You can only call PubstarAdView after PubstarIo.instance.init() has been successfully initialized.
/// - The [adId] parameter must be a valid ad unit ID from your ad provider.
/// - Place this widget inside your widget tree where you want the ad to appear.
/// - Handles lifecycle and automatically calls `showAdWithViewId`.
class PubstarAdView extends StatelessWidget {
  const PubstarAdView({super.key, required this.adId});

  /// The ad unit ID to be loaded and displayed in this view.
  ///
  /// You should use the ad ID provided by your ad network or backend.
  final String adId;

  Widget build(BuildContext context) {
    const String viewType = Constance.viewType;

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int viewId) {
        PubstarIo.instance.showAdWithViewId(adId: adId, viewId: viewId);
      },
    );
  }
}
