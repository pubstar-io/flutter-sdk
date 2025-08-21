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
    await PubstarIo.init();

    // *** Preload Ad ***
    // await loadAd(AdIdExample.bannerId);
    // await loadAd(AdIdExample.nativeId);
    // await loadAd(AdIdExample.interstitialId);
    // await loadAd(AdIdExample.openId);
    // await loadAd(AdIdExample.rewardedId);
    // await loadAd(AdIdExample.videoId);
    // *** End preload Ad ***
  }

  Future<void> loadAd(String adId) async {
    await PubstarIo.loadAd(
      adId,
      LoadListener(
        onLoaded: () => print("FLUTTER - app: onLoaded loadAd"),
        onError:
            (error) => print(
              "FLUTTER - app: onError loadAd, code: ${error.code} - rawCode: ${error.name}",
            ),
      ),
    );
  }

  Future<void> showAd(String adId) async {
    await PubstarIo.showAd(
      adId,
      ShowListener(
        onShowed: () => print("FLUTTER - app: onShowed showAd"),
        onHide:
            (reward) => print(
              "FLUTTER - app: onHide showAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
            ),
        onError:
            (error) => print(
              "FLUTTER - app: onError showAd, code: ${error.code} - name: ${error.name} - message: ${error.message}",
            ),
      ),
    );
  }

  Future<void> loadAndShowAd(String adId) async {
    await PubstarIo.loadAndShow(
      adId,
      LoadAndShowNoViewListener(
        onError:
            (error) => print(
              "FLUTTER - app: onError loadAndShowAd, code: ${error.code} - rawCode: ${error.name}",
            ),
        onHide:
            (reward) => print(
              "FLUTTER - app: onHide loadAndShowAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
            ),
        onLoaded: () => print("FLUTTER - app: onLoaded loadAndShowAd"),
        onShowed: () => print("FLUTTER - app: onShowed loadAndShowAd"),
      ),
    );
  }
}
