import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_core.dart';

class PubstarAdView extends StatelessWidget {
  const PubstarAdView({super.key, required this.adId});

  final String adId;

  Widget build(BuildContext context) {
    const String viewType = MethodChannelName.viewType;

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
