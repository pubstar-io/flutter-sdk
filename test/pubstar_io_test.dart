import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/src/pubstar_io_platform_interface.dart';
import 'package:pubstar_io/src/pubstar_io_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPubstarIoPlatform
    with MockPlatformInterfaceMixin
    implements PubstarIoPlatform {
  @override
  Future<bool?> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<bool?> loadAd(String adId) {
    // TODO: implement loadAd
    throw UnimplementedError();
  }

  @override
  Future<String?> showAd({required String adId, int? viewId}) {
    // TODO: implement showAd
    throw UnimplementedError();
  }

  @override
  Future<String?> showAdWithViewId({
    required String adId,
    required int viewId,
  }) {
    // TODO: implement showAdWithViewId
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowAd(String adId) {
    // TODO: implement loadAndShowAd
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowAdViewId({
    required String adId,
    required int viewId,
  }) {
    // TODO: implement loadAndShowAdViewId
    throw UnimplementedError();
  }

  @override
  Future<void> loadAndShowAdWithViewId({
    required String adId,
    required int viewId,
  }) {
    // TODO: implement loadAndShowAdWithViewId
    throw UnimplementedError();
  }
}

void main() {
  final PubstarIoPlatform initialPlatform = PubstarIoPlatform.instance;

  test('$MethodChannelPubstarIo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPubstarIo>());
  });
}
