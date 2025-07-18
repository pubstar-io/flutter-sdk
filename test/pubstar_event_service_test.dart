// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/method_channel_name.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PubstarEventService', () {
    const channelName = Constance.eventChannelName;

    final binaryMessenger = ServicesBinding.instance.defaultBinaryMessenger;

    final fakeEvents = [
      {'event': 'SHOWED', 'adId': 'abc'},
      {'event': 'HIDE', 'adId': 'abc'},
    ];

    late StreamController<dynamic> controller;

    setUp(() {
      controller = StreamController.broadcast();

      binaryMessenger.setMockMessageHandler(channelName, (
        ByteData? message,
      ) async {
        final methodCall = const StandardMethodCodec().decodeMethodCall(
          message,
        );

        if (methodCall.method == 'listen') {
          Future.delayed(Duration.zero, () {
            for (final e in fakeEvents) {
              final byteData = const StandardMethodCodec()
                  .encodeSuccessEnvelope(e);
              binaryMessenger.handlePlatformMessage(
                channelName,
                byteData,
                (_) {},
              );
            }
          });
        }
        return const StandardMethodCodec().encodeSuccessEnvelope(null);
      });
    });

    tearDown(() async {
      await controller.close();
      binaryMessenger.setMockMessageHandler(channelName, null);
    });

    test(
      'PubstarEventService should receive events from mocked native stream',
      () async {
        final received = <dynamic>[];

        final sub = PubstarEventService().listen((event) {
          received.add(event);
        });

        await Future.delayed(const Duration(milliseconds: 100));
        await sub.cancel();

        expect(received.length, 2);
        expect(received[0]['event'], 'SHOWED');
        expect(received[1]['event'], 'HIDE');
      },
    );
  });
}
