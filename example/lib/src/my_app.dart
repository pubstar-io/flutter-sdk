import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io_example/src/controller.dart';
import 'dart:developer';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final controller = Controller();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAdSdkReady = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    widget.controller.initPubstar().then((_) {
      setState(() {
        _isAdSdkReady = true;
      });
    });

    _subscription = PubstarEventService().listen((data) {
      log('📩 Event from native: $data');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  Widget buildPlaceholder() {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: SizedBox(width: double.infinity, height: 100),
    );
  }

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
                        mode: PubstarAdViewMode.loadAndShow,
                        type: PubstarAdType.banner,
                        size: PubstarAdSize.small,
                        onError:
                            (error) => print(
                              "FLUTTER - app: onError banner, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => print(
                              "FLUTTER - app: onHide banner  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => print(
                              "FLUTTER - app: onLoaded banner",
                            ),
                        onShowed:
                            () => print(
                              "FLUTTER - app: onShowed banner",
                            ),
                      ),
                    ),
                  )
                  : buildPlaceholder(),

              Text('Native AD'),
              const SizedBox(height: 10),
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
                            (error) => print(
                              "FLUTTER - app: onError native, code: ${error.code} - rawCode: ${error.name}",
                            ),
                        onHide:
                            (reward) => print(
                              "FLUTTER - app: onHide native  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
                            ),
                        onLoaded:
                            () => print(
                              "FLUTTER - app: onLoaded native",
                            ),
                        onShowed:
                            () => print(
                              "FLUTTER - app: onShowed native",
                            ),
                      ),
                    ),
                  )
                  : buildPlaceholder(),
              const SizedBox(height: 10),

              // Text('Video AD'),
              // const SizedBox(height: 10),
              // _isAdSdkReady
              //     ? ColoredBox(
              //       color: Colors.grey.shade300,
              //       child: SizedBox(
              //         width: double.infinity,
              //         height: 200,
              //         child: PubstarVideoAdView(
              //           adId: AdIdExample.videoId,
              //           media:
              //               'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
              //         ),
              //       ),
              //     )
              //     : buildPlaceholder(),
              const SizedBox(height: 10),
              Text('-------------------------'),

              Text('AD not need view Example'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.controller.loadAd(AdIdExample.interstitialId);
                },
                child: const Text('Show Interstitial Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.interstitialId);
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
