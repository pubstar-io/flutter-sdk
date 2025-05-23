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
      await PubstarIo.instance.loadAd(AdIdExample.interstitialId);
      print("initPubstar success");
    } catch (e) {
      print("initPubstar error: $e");
    }
  }

  Future<void> showAd() async {
    try {
      await PubstarIo.instance.showAd(AdIdExample.interstitialId);
      print("showAd success");
    } catch (e) {
      print("showAd error: $e");
    }
  }
}
