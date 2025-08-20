import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/pubstar_types.dart';

import 'pubstar_io_method_channel.dart';

abstract class PubstarIoPlatform extends PlatformInterface {
  /// Constructs a PubstarIoPlatform.
  PubstarIoPlatform() : super(token: _token);

  static final Object _token = Object();

  static PubstarIoPlatform _instance = MethodChannelPubstarIo();

  /// The default instance of [PubstarIoPlatform] to use.
  ///
  /// Defaults to [MethodChannelPubstarIo].
  static PubstarIoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PubstarIoPlatform] when
  /// they register themselves.
  static set instance(PubstarIoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> loadAd(String adId, [LoadListener? listener]) {
    throw UnimplementedError('loadAd() has not been implemented.');
  }

  Future<void> showAd(String adId, [ShowListener? listener]) {
    throw UnimplementedError('showAd() has not been implemented.');
  }

  Future<void> showAdWithViewId({required String adId, required int viewId}) {
    throw UnimplementedError('showAdWithViewId() has not been implemented.');
  }

  Future<void> loadAndShowAd(String adId, [LoadAndShowListener? listener]) {
    throw UnimplementedError('loadAndShowAd() has not been implemented.');
  }

  Future<void> loadAndShowAdWithViewId({
    required String adId,
    required int viewId,
  }) {
    throw UnimplementedError(
      'loadAndShowAdWithViewId() has not been implemented.',
    );
  }

  Future<void> loadAndShowBannerAd({
    required String adId,
    required int viewId,
    required PubstarAdSize tag,
  }) {
    throw UnimplementedError('loadAndShowBannerAd() has not been implemented.');
  }

  Future<void> loadAndShowNativeAd({
    required String adId,
    required int viewId,
    required PubstarAdSize typeSize,
  }) {
    throw UnimplementedError('loadAndShowNativeAd() has not been implemented.');
  }

  Future<void> loadAndShowVideoAd({
    required String adId,
    required int viewId,
    required String media,
  }) {
    throw UnimplementedError('loadAndShowVideoAd() has not been implemented.');
  }
}
