import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/src/pubstar_ad_view.dart';
import 'package:pubstar_io/src/pubstar_io_platform_interface.dart';
import 'package:pubstar_io/src/pubstar_io_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pubstar_io/src/pubstar_types.dart';

class MockPubstarIoPlatform
    with MockPlatformInterfaceMixin
    implements PubstarIoPlatform {
  @override
  Future<bool?> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> loadAd(String adId, [LoadListener? listener]) {
    // TODO: implement loadAd
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShow(String adId, [LoadAndShowNoViewListener? listener]) {
    // TODO: implement loadAndShowAd
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowAdWithViewId({
    required String adId,
    required int viewId,
    LoadAndShowListener? listener,
  }) {
    // TODO: implement loadAndShowAdWithViewId
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowBannerAd({
    required String adId,
    required int viewId,
    required PubstarAdSize tag,
    LoadAndShowListener? listener,
  }) {
    // TODO: implement loadAndShowBannerAd
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowNativeAd({
    required String adId,
    required int viewId,
    required PubstarAdSize typeSize,
    LoadAndShowListener? listener,
  }) {
    // TODO: implement loadAndShowNativeAd
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowVideoAd({
    required String adId,
    required int viewId,
    required String media,
    LoadAndShowListener? listener,
  }) {
    // TODO: implement loadAndShowVideoAd
    throw UnimplementedError();
  }

  @override
  Future<void> showAd(String adId, [ShowListener? listener]) {
    // TODO: implement showAd
    throw UnimplementedError();
  }

  @override
  Future<void> showAdWithViewId({
    required String adId,
    required int viewId,
    ShowListener? listener,
  }) {
    // TODO: implement showAdWithViewId
    throw UnimplementedError();
  }
}

void main() {
  final PubstarIoPlatform initialPlatform = PubstarIoPlatform.instance;

  test('$MethodChannelPubstarIo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPubstarIo>());
  });
}
