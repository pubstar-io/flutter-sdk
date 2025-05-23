import 'pubstar_io_platform_interface.dart';

class PubstarIo {
  PubstarIo._internal();

  static final PubstarIo _instance = PubstarIo._internal();

  static PubstarIo get instance => _instance;

  Future<bool?> init() async {
    return await PubstarIoPlatform.instance.init();
  }

  Future<bool?> loadAd(String adId) async {
    return await PubstarIoPlatform.instance.loadAd(adId);
  }

  Future<String?> showAd(String adId) async {
    return await PubstarIoPlatform.instance.showAd(adId);
  }
}
