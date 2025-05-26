import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  Future<String?> showAd({required String adId}) async {
    return await PubstarIoPlatform.instance.showAd(adId: adId);
  }

  Future<String?> showAdWithViewId({
    required String adId,
    required int viewId,
  }) async {
    return await PubstarIoPlatform.instance.showAdWithViewId(
      adId: adId,
      viewId: viewId,
    );
  }

  Future<String?> loadAndShowAd({
    required String adId,
    required int viewId,
  }) async {
    return await PubstarIoPlatform.instance.loadAndShowAd(
      adId: adId,
      viewId: viewId,
    );
  }
}

class PubstarAdView extends StatelessWidget {
  const PubstarAdView({super.key, required this.adId});

  final String adId;

  Widget build(BuildContext context) {
    const String viewType = 'pubstar_ad_view';

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int viewId) {
        print('PubstarAdView created with viewId: $viewId');
        PubstarIo.instance.showAdWithViewId(adId: adId, viewId: viewId);
      },
    );
  }
}
