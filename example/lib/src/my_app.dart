import 'package:flutter/material.dart';
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
              Text('AD Example'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.controller.showAd();
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
