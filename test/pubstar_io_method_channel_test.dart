import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/pubstar_io_method_channel.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelPubstarIo platform;
  const MethodChannel channel = MethodChannel('pubstar_io');

  setUp(() {
    platform = MethodChannelPubstarIo();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelPubstarIo', () {
    test('init method should run success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            expect(methodCall.method, 'init');
            return null;
          });

      expect(() async => await platform.init(), returnsNormally);
    });

    test(
      'init method should throw PubstarIoException when PlatformException',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'NO_INIT',
                message: 'Not initialized',
              );
            });

        expect(
          () async => await platform.init(),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test('loadAd method should expect adId argument', () async {
      const testAdId = 'ad_example_id';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            expect(methodCall.method, 'loadAd');
            expect(methodCall.arguments, {'adId': testAdId});
            return null;
          });

      expect(() async => await platform.loadAd(testAdId), returnsNormally);
    });

    test(
      'loadAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.showAd(adId: testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test('loadAd method should expect adId argument', () async {
      const testAdId = 'ad_example_id';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            expect(methodCall.method, 'loadAd');
            expect(methodCall.arguments, {'adId': testAdId});
            return null;
          });

      expect(() async => await platform.loadAd(testAdId), returnsNormally);
    });

    test(
      'showAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.showAd(adId: testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'showAdWithViewId method should expect adId and viewId arguments',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 77;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'showAdWithViewId');
              expect(methodCall.arguments, {
                'adId': testAdId,
                'viewId': viewId,
              });
              return null;
            });

        expect(
          () async =>
              await platform.showAdWithViewId(adId: testAdId, viewId: viewId),
          returnsNormally,
        );
      },
    );

    test(
      'showAdWithViewId method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 77;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async =>
              await platform.showAdWithViewId(adId: testAdId, viewId: viewId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'loadAndShowAd method should expect adId and viewId arguments',
      () async {
        const testAdId = 'ad_example_id';
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'loadAndShowAd');
              expect(methodCall.arguments, {'adId': testAdId});
              return null;
            });

        expect(
          () async => await platform.loadAndShowAd(testAdId),
          returnsNormally,
        );
      },
    );

    test(
      'loadAndShowAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 77;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.loadAndShowAd(testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );
  });
}
