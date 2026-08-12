import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io_example/src/controller.dart';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final controller = Controller();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAdSdkReady = false;

  @override
  void initState() {
    super.initState();

    widget.controller.initPubstar().then((_) {
      setState(() {
        _isAdSdkReady = true;
      });
    });
  }

  Widget buildPlaceholder() {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: SizedBox(width: double.infinity, height: 100),
    );
  }

  final customConfig =
      Platform.isAndroid
          ? PubstarNativeCustomConfig(
            layoutName: "pubstar_admob_native_big",
            advertiserTextViewId: "ad_advertiser",
            iconImageViewId: "ad_logo",
            titleTextViewId: "ad_headline",
            mediaContentViewGroupId: "ad_media",
            bodyTextViewId: "ad_body",
            callToActionButtonId: "ad_call_to_action",
            loadingViewId: "pubstar_shimmer_native_big",
            ctaColorHex: "#FFFFFF",
          )
          : PubstarNativeCustomConfig(
            layoutName: "AppAdmobNativeCustom",
            advertiserTextViewId: "1",
            iconImageViewId: "2",
            titleTextViewId: "3",
            mediaContentViewGroupId: "4",
            bodyTextViewId: "5",
            callToActionButtonId: "6",
            loadingViewId: "AppShimmerBanner",
            ctaColorHex: "#FFFFFF",
          );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin Pubstar IO example')),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('AD need view Example'),
              const SizedBox(height: 20),
              Text('Banner AD'),
              const SizedBox(height: 10),
              _isAdSdkReady
                  ? ColoredBox(
                    color: Colors.grey.shade300,
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: PubstarAdView(
                        adId: AdIdExample.bannerId,
                        size: PubstarAdSize.small,
                        type: PubstarAdType.banner,
                        mode: PubstarAdViewMode.loadAndShow,
                        onError:
                            (error) => debugPrint(
                              "FLUTTER - app: onError banner, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => debugPrint(
                              "FLUTTER - app: onHide banner  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => debugPrint("FLUTTER - app: onLoaded banner"),
                        onShowed:
                            () => debugPrint("FLUTTER - app: onShowed banner"),
                      ),
                    ),
                  )
                  : buildPlaceholder(),

              const SizedBox(height: 10),
              Text('Native AD'),
              _isAdSdkReady
                  ? ColoredBox(
                    color: Colors.grey.shade300,
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: PubstarAdView(
                        adId: AdIdExample.nativeId,
                        mode: PubstarAdViewMode.loadAndShow,
                        type: PubstarAdType.native,
                        size: PubstarAdSize.small,
                        onError:
                            (error) => debugPrint(
                              "FLUTTER - app: onError native, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => debugPrint(
                              "FLUTTER - app: onHide native  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => debugPrint("FLUTTER - app: onLoaded native"),
                        onShowed:
                            () => debugPrint("FLUTTER - app: onShowed native"),
                      ),
                    ),
                  )
                  : buildPlaceholder(),

              const SizedBox(height: 10),
              Text('Custom Native AD'),
              _isAdSdkReady
                  ? ColoredBox(
                    color: Colors.grey.shade300,
                    child: SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: PubstarAdView(
                        adId: AdIdExample.nativeId,
                        mode: PubstarAdViewMode.loadAndShow,
                        type: PubstarAdType.native,
                        size: PubstarAdSize.small,
                        nativeCustomConfig: customConfig,
                        onError:
                            (error) => debugPrint(
                              "FLUTTER - app: onError custom native, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => debugPrint(
                              "FLUTTER - app: onHide custom native  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => debugPrint(
                              "FLUTTER - app: onLoaded custom native",
                            ),
                        onShowed:
                            () => debugPrint(
                              "FLUTTER - app: onShowed custom native",
                            ),
                      ),
                    ),
                  )
                  : buildPlaceholder(),

              Text('Video AD'),
              const SizedBox(height: 10),
              _isAdSdkReady
                  ? ColoredBox(
                    color: Colors.grey.shade300,
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: PubstarVideoAdView(
                        adId: AdIdExample.videoId,
                        media:
                            'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
                        type: PubStarVideoAdType.outStream,
                        onError:
                            (error) => debugPrint(
                              "FLUTTER - app: video onError, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => debugPrint(
                              "FLUTTER - app: video onHide  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => debugPrint("FLUTTER - app: video onLoaded"),
                        onShowed:
                            () => debugPrint("FLUTTER - app: video onShowed"),
                      ),
                    ),
                  )
                  : buildPlaceholder(),
              const SizedBox(height: 10),
              Text('-------------------------'),

              Text('AD not need view Example'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.controller.loadAndShowAd(AdIdExample.interstitialId);
                },
                child: const Text('Show Interstitial Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.loadAndShowAd(AdIdExample.openId);
                },
                child: const Text('Show Open Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.loadAndShowAd(AdIdExample.rewardedId);
                },
                child: const Text('Show Rewarded Ad'),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
