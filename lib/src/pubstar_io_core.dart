import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/pubstar_io_platform_interface.dart';
import 'package:pubstar_io/src/pubstar_types.dart';

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
  Future<void> loadAd(String adId, [LoadListener? listener]) async {
    await PubstarIoPlatform.instance.loadAd(adId, listener);
  }

  /// Shows an ad only once using the given [adId].
  ///
  /// You should call [loadAd] before calling this method.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.showAd(adId: 'your_ad_id');
  /// ```
  Future<void> showAd(String adId, [ShowListener? listener]) async {
    await PubstarIoPlatform.instance.showAd(adId, listener);
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
  Future<void> loadAndShowAd(
    String adId, [
    LoadAndShowListener? listener,
  ]) async {
    await PubstarIoPlatform.instance.loadAndShowAd(adId, listener);
  }

  /// Loads and shows an ad using [adId] and [viewId].
  ///
  /// Typically used with [ViewGroup] widget.
  ///
  /// Example:
  /// ```dart
  /// await PubstarIo.instance.loadAndShowAdWithViewId(adId: 'your_ad_id', viewId: 123);
  /// ```
  Future<void> loadAndShowAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowAdWithViewId(
      adId: adId,
      viewId: viewId,
    );
  }

  Future<void> loadAndShowBannerAd({
    required String adId,
    required int viewId,
    required PubstarAdSize size,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowBannerAd(
      adId: adId,
      viewId: viewId,
      tag: size,
    );
  }

  Future<void> loadAndShowNativeAd({
    required String adId,
    required int viewId,
    required PubstarAdSize size,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowNativeAd(
      adId: adId,
      viewId: viewId,
      typeSize: size,
    );
  }

  Future<void> loadAndShowVideoAd({
    required String adId,
    required int viewId,
    required String media,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowVideoAd(
      adId: adId,
      viewId: viewId,
      media: media,
    );
  }
}
