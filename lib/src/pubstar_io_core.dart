import 'package:pubstar_io/src/pubstar_io_platform_interface.dart';

class PubstarIo {
  PubstarIo._internal();

  static final PubstarIo _instance = PubstarIo._internal();

  static PubstarIo get instance => _instance;

  Future<void> init() async {
    await PubstarIoPlatform.instance.init();
  }

  Future<void> loadAd(String adId) async {
    await PubstarIoPlatform.instance.loadAd(adId);
  }

  Future<void> showAd({required String adId}) async {
    await PubstarIoPlatform.instance.showAd(adId: adId);
  }

  Future<void> showAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    await PubstarIoPlatform.instance.showAdWithViewId(
      adId: adId,
      viewId: viewId,
    );
  }

  Future<void> loadAndShowAd({
    required String adId,
    required int viewId,
  }) async {
    await PubstarIoPlatform.instance.loadAndShowAd(adId);
  }

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
