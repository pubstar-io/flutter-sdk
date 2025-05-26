import 'package:pubstar_io/pubstar_io.dart';

class AdIdExample {
  static const String bannerId = "1233/99228313580";
  static const String nativeId = "1233/99228313581";
  static const String interstitialId = "1233/99228313582";
  static const String openId = "1233/99228313583";
  static const String rewardedId = "1233/99228313584";
  static const String videoId = "1233/99228313585";
}

class Controller {
  Future<void> initPubstar() async {
    try {
      await PubstarIo.instance.init();

      await loadAd(AdIdExample.bannerId);
      await loadAd(AdIdExample.nativeId);
      await loadAd(AdIdExample.interstitialId);
      await loadAd(AdIdExample.openId);
      await loadAd(AdIdExample.rewardedId);
      await loadAd(AdIdExample.videoId);
      print("initPubstar success");
    } catch (e) {
      print("initPubstar error: $e");
    }
  }

  Future<void> loadAd(String adId) async {
    try {
      await PubstarIo.instance.loadAd(adId);
      print("loadAd success");
    } catch (e) {
      print("loadAd error: $e");
    }
  }

  Future<void> showAd(String adId) async {
    try {
      await PubstarIo.instance.showAd(adId: adId);
      print("showAd success");
    } catch (e) {
      print("Controller showAd error: $e");
    }
  }
}
