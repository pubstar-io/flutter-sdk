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
  @override
  void initState() {
    super.initState();

    widget.controller.initPubstar();
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
              ColoredBox(
                color: Colors.grey.shade300,
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: PubstarAdView(adId: AdIdExample.bannerId),
                ),
              ),
              Text('AD Example'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.bannerId);
                },
                child: const Text('Show Banner Ad'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.nativeId);
                },
                child: const Text('Show Native Ad'),
              ),

              const SizedBox(height: 10),
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

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd(AdIdExample.videoId);
                },
                child: const Text('Show Video Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
