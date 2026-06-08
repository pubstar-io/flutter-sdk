import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pubstar_io/pubstar_io.dart';

class AdIdExample {
  static const _android = _AdIds(
    bannerId: '1687/99228314074',
    nativeId: '1687/99228314077',
    interstitialId: '1687/99228314068',
    openId: '1687/99228314075',
    rewardedId: '1687/99228314076',
    videoId: '1687/99228314122',
  );

  static const _ios = _AdIds(
    bannerId: '1692/99228314092',
    nativeId: '1692/99228314093',
    interstitialId: '1692/99228314089',
    openId: '1692/99228314090',
    rewardedId: '1692/99228314091',
    videoId: '1692/99228314124',
  );

  static _AdIds get _config => Platform.isIOS ? _ios : _android;

  static String get bannerId => _config.bannerId;
  static String get nativeId => _config.nativeId;
  static String get interstitialId => _config.interstitialId;
  static String get openId => _config.openId;
  static String get rewardedId => _config.rewardedId;
  static String get videoId => _config.videoId;
}

class _AdIds {
  final String bannerId;
  final String nativeId;
  final String interstitialId;
  final String openId;
  final String rewardedId;
  final String videoId;

  const _AdIds({
    required this.bannerId,
    required this.nativeId,
    required this.interstitialId,
    required this.openId,
    required this.rewardedId,
    required this.videoId,
  });
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
