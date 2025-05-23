import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pubstar_io/pubstar_io.dart';

Future<void> initPubstar() async {
  try {
    await PubstarIo.instance.init();
    await PubstarIo.instance.loadAd("1233/99228313582");
    print("initPubstar success");
  } catch (e) {
    print("initPubstar error: $e");
  }
}

Future<void> showAd() async {
  try {
    await PubstarIo.instance.showAd("1233/99228313582");
    print("showAd success");
  } catch (e) {
    print("showAd error: $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPubstar();
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
              Text('AD Example'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showAd();
                },
                child: const Text('Show AD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
