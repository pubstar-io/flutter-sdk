import 'dart:async';

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
  late final StreamSubscription sub;

  @override
  void initState() {
    super.initState();

    widget.controller.initPubstar().then((_) {
      setState(() {
        _isAdSdkReady = true;
      });
    });

    sub = PubstarAdEventStream.stream.listen((event) {
      print('Received ad event: $event');
    });
  }

  @override
  void dispose() {
    sub.cancel();
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text('Banner AD'),
              // _isAdSdkReady
              //     ? ColoredBox(
              //       color: Colors.grey.shade300,
              //       child: SizedBox(
              //         width: double.infinity,
              //         height: 100,
              //         child: PubstarAdView(
              //           adId: AdIdExample.bannerId,
              //           mode: PubstarAdViewMode.loadAndShow,
              //         ),
              //       ),
              //     )
              //     : buildPlaceholder(),
              // const SizedBox(height: 10),

              // Text('Native AD'),
              // _isAdSdkReady
              //     ? ColoredBox(
              //       color: Colors.grey.shade300,
              //       child: SizedBox(
              //         width: double.infinity,
              //         height: 100,
              //         child: PubstarAdView(
              //           adId: AdIdExample.nativeId,
              //           mode: PubstarAdViewMode.loadAndShow,
              //         ),
              //       ),
              //     )
              //     : buildPlaceholder(),
              // const SizedBox(height: 10),

              // Text('Video AD'),
              // _isAdSdkReady
              //     ? ColoredBox(
              //       color: Colors.grey.shade300,
              //       child: SizedBox(
              //         width: double.infinity,
              //         height: 200,
              //         child: PubstarAdView(
              //           adId: AdIdExample.videoId,
              //           mode: PubstarAdViewMode.loadAndShow,
              //         ),
              //       ),
              //     )
              //     : buildPlaceholder(),
              // const SizedBox(height: 10),
              Text('AD Example'),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.interstitialId);
                },
                child: const Text('Show Interstitial Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.openId);
                },
                child: const Text('Show Open Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.rewardedId);
                },
                child: const Text('Show Rewarded Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
