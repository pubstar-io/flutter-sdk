import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubstar_io/pubstar_io.dart';
import 'package:pubstar_io/src/callback_handler.dart';
import 'package:pubstar_io/src/method_channel_name.dart';
import 'package:pubstar_io/src/pubstar_io_method_channel.dart';
import 'package:pubstar_io/src/pubstar_io_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelPubstarIo platform;
  const MethodChannel channel = MethodChannel(Constance.methodChannelName);

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

    test('loadAd should call methodChannel with adId and callbackId', () async {
      const testAdId = 'ad_example_id';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            expect(methodCall.method, 'loadAd');

            final args = methodCall.arguments as Map;

            expect(args['adId'], testAdId);
            expect(args['callbackId'], isNotNull);
            expect(args['callbackId'], isA<String>());

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
          () async => await platform.showAd(testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

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
          () async => await platform.showAd(testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'showAdWithViewId method should expect adId and viewId arguments',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'showAdWithViewId');

              final args = methodCall.arguments as Map;

              expect(args['adId'], testAdId);
              expect(args['viewId'], viewId);
              expect(args['callbackId'], isNotNull);
              expect(args['callbackId'], isA<String>());

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
        const viewId = 83;

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
      'loadAndShow method should expect adId and viewId arguments',
      () async {
        const testAdId = 'ad_example_id';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'loadAndShowAd');

              final args = methodCall.arguments as Map<Object?, Object?>;

              expect(args['adId'], testAdId);
              expect(args['callbackId'], isNotNull);
              expect(args['callbackId'], isA<String>());

              return null;
            });

        expect(
          () async => await platform.loadAndShow(testAdId),
          returnsNormally,
        );
      },
    );

    test(
      'loadAndShowAd method should throw PubstarIoException when PlatformException',
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
          () async => await platform.loadAndShow(testAdId),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'loadAndShowAdWithViewId method should expect adId and viewId arguments',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'loadAndShowAdWithViewId');

              final args = methodCall.arguments as Map;

              expect(args['adId'], testAdId);
              expect(args['viewId'], viewId);
              expect(args['callbackId'], isNotNull);
              expect(args['callbackId'], isA<String>());

              return null;
            });

        expect(
          () async => await platform.loadAndShowAdWithViewId(
            adId: testAdId,
            viewId: viewId,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'loadAndShowAdWithViewId method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.loadAndShowAdWithViewId(
            adId: testAdId,
            viewId: viewId,
          ),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'loadAndShowBannerAd method should expect adId, viewId, tag arguments',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;
        const tag = PubstarAdSize.small;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'loadAndShowBannerAd');

              final args = methodCall.arguments as Map<Object?, Object?>;

              expect(args['adId'], testAdId);
              expect(args['viewId'], viewId);
              expect(args['tag'], tag.name);
              expect(args['callbackId'], isNotNull);
              expect(args['callbackId'], isA<String>());

              return null;
            });

        expect(
          () async => await platform.loadAndShowBannerAd(
            adId: testAdId,
            viewId: viewId,
            tag: tag,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'loadAndShowBannerAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;
        const tag = PubstarAdSize.small;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.loadAndShowBannerAd(
            adId: testAdId,
            viewId: viewId,
            tag: tag,
          ),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test('loadAndShowBannerAd should send correct arguments', () async {
      const testAdId = 'ad_example_id';
      const viewId = 83;
      const tag = PubstarAdSize.small;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            expect(methodCall.method, 'loadAndShowBannerAd');

            final args = methodCall.arguments as Map<Object?, Object?>;

            expect(args['adId'], testAdId);
            expect(args['viewId'], viewId);
            expect(args['tag'], tag.name);
            expect(args['callbackId'], isNotNull);
            expect(args['callbackId'], isA<String>());

            return null;
          });

      expect(
        () async => await platform.loadAndShowBannerAd(
          adId: testAdId,
          viewId: viewId,
          tag: tag,
        ),
        returnsNormally,
      );
    });

    test(
      'loadAndShowBannerAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;
        const tag = PubstarAdSize.small;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.loadAndShowBannerAd(
            adId: testAdId,
            viewId: viewId,
            tag: tag,
          ),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );

    test(
      'loadAndShowVideoAd method should expect adId, viewId, tag arguments',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;
        const media = 'https://example.com/video.mp4';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              expect(methodCall.method, 'loadAndShowVideoAd');

              final args = methodCall.arguments as Map<Object?, Object?>;

              expect(args['adId'], testAdId);
              expect(args['viewId'], viewId);
              expect(args['media'], media);
              expect(args['callbackId'], isNotNull);
              expect(args['callbackId'], isA<String>());

              return null;
            });

        expect(
          () async => await platform.loadAndShowVideoAd(
            adId: testAdId,
            viewId: viewId,
            media: media,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'loadAndShowVideoAd method should throw PubstarIoException when PlatformException',
      () async {
        const testAdId = 'ad_example_id';
        const viewId = 83;
        const media = 'https://example.com/video.mp4';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              throw PlatformException(
                code: 'SHOW_ERROR',
                message: 'Show error',
              );
            });

        expect(
          () async => await platform.loadAndShowVideoAd(
            adId: testAdId,
            viewId: viewId,
            media: media,
          ),
          throwsA(isA<PubstarIoException>()),
        );
      },
    );
  });
}
