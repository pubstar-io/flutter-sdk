import 'package:flutter/foundation.dart';
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
      await PubstarIo.init();
    } on PubstarIoException catch (e) {
      print(
        "FLUTTER - app: init Pubstar SDK error ${e.errorCode} - ${e.message} - ${e.details}",
      );
    }

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
        onLoaded: () => debugPrint("FLUTTER - app: onLoaded loadAd"),
        onError:
            (error) => debugPrint(
              "FLUTTER - app: onError loadAd, code: ${error.code} - rawCode: ${error.name}",
            ),
      ),
    );
  }

  Future<void> showAd(String adId) async {
    await PubstarIo.showAd(
      adId,
      ShowListener(
        onShowed: () => debugPrint("FLUTTER - app: onShowed showAd"),
        onHide:
            (reward) => debugPrint(
              "FLUTTER - app: onHide showAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
            ),
        onError:
            (error) => debugPrint(
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
            (error) => debugPrint(
              "FLUTTER - app: onError loadAndShowAd, code: ${error.code} - rawCode: ${error.name}",
            ),
        onHide:
            (reward) => debugPrint(
              "FLUTTER - app: onHide loadAndShowAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
            ),
        onLoaded: () => debugPrint("FLUTTER - app: onLoaded loadAndShowAd"),
        onShowed: () => debugPrint("FLUTTER - app: onShowed loadAndShowAd"),
      ),
    );
  }
}
