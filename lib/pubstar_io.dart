import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'pubstar_io_platform_interface.dart';

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
    await PubstarIoPlatform.instance.loadAndShowAd(adId: adId, viewId: viewId);
  }
}

class PubstarAdEventStream {
  static final _eventChannel = const EventChannel('pubstar_io_event');

  static Stream<Map<dynamic, dynamic>> get stream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event as Map<dynamic, dynamic>);
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
        PubstarIo.instance.showAdWithViewId(adId: adId, viewId: viewId);
      },
    );
  }
}
