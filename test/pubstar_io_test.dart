import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/pubstar_io_platform_interface.dart';
import 'package:pubstar_io/pubstar_io_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPubstarIoPlatform
    with MockPlatformInterfaceMixin
    implements PubstarIoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

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
  Future<String?> loadAndShowAd({required String adId, required int viewId}) {
    // TODO: implement loadAndShowAd
    throw UnimplementedError();
  }
}

void main() {
  final PubstarIoPlatform initialPlatform = PubstarIoPlatform.instance;

  test('$MethodChannelPubstarIo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPubstarIo>());
  });

  test('getPlatformVersion', () async {
    PubstarIo pubstarIoPlugin = PubstarIo.instance;
    MockPubstarIoPlatform fakePlatform = MockPubstarIoPlatform();
    PubstarIoPlatform.instance = fakePlatform;

    expect(await pubstarIoPlugin.init(), 'true');
  });
}
