import 'package:pubstar_io/src/pubstar_io_platform_interface.dart';

/// The main singleton entry-point for Pubstar IO Ads SDK.
///
/// Use [PubstarIo.instance] to access all ad-related methods.
/// Example usage:
/// ```dart
/// await PubstarIo.instance.init();
/// await PubstarIo.instance.loadAd('your_ad_id');
/// await PubstarIo.instance.showAd(adId: 'your_ad_id');
/// ```
class PubstarIo {
  PubstarIo._internal();

  static final PubstarIo _instance = PubstarIo._internal();

  static PubstarIo get instance => _instance;

  /// Initializes the Pubstar IO Ads SDK.
  ///
  /// Must be called **once** before loading or showing any ad.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.init();
  /// ```
  Future<void> init() async {
    await PubstarIoPlatform.instance.init();
  }

  /// Loads an ad with the given [adId].
  ///
  /// Should be called before [showAd] or [showAdWithViewId].
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.loadAd('your_ad_id');
  /// ```
  Future<void> loadAd(String adId) async {
    await PubstarIoPlatform.instance.loadAd(adId);
  }

  /// Shows an ad only once using the given [adId].
  ///
  /// You should call [loadAd] before calling this method.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.showAd(adId: 'your_ad_id');
  /// ```
  Future<void> showAd({required String adId}) async {
    await PubstarIoPlatform.instance.showAd(adId: adId);
  }

  /// Shows an ad only one in a specific native view, using [adId] and [viewId].
  ///
  /// Typically used with [PubstarAdView] widget.
  ///
  /// Example:
  /// ```dart
  /// PubstarAdView(adId: 'your_ad_id')
  /// // Trong callback onPlatformViewCreated:
  /// await PubstarIo.instance.showAdWithViewId(adId: 'your_ad_id', viewId: viewId);
  /// ```
  Future<void> showAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    await PubstarIoPlatform.instance.showAdWithViewId(
      adId: adId,
      viewId: viewId,
    );
  }

  /// Loads and shows an ad in a single step with [adId].
  ///
  /// Useful for "quick ad" scenarios when you don't want to manage loading state separately.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.loadAndShowAd('your_ad_id');
  /// ```
  Future<void> loadAndShowAd(String adId) async {
    await PubstarIoPlatform.instance.loadAndShowAd(adId);
  }

  /// Loads and shows an ad using [adId] and [viewId].
  ///
  /// Typically used with [PubstarAdView] widget.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.loadAndShowAdViewId(adId: 'your_ad_id', viewId: 123);
  /// ```
  Future<void> loadAndShowAdViewId({
    required String adId,
    required int viewId,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowAdViewId(
      adId: adId,
      viewId: viewId,
    );
  }
}
