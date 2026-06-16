## PubStar SDK

PubStar Mobile Ads SDK is a comprehensive monetization solution that enables developers to seamlessly integrate high-performance ad formats into mobile applications across multiple platforms:

- [iOS](https://pub-star.gitbook.io/docs/ios-sdk/integration)
- [Android](https://pub-star.gitbook.io/docs/android-sdk/integration)
- [React Native](https://pub-star.gitbook.io/docs/react-native-sdk/integration)
- [Flutter](https://pub-star.gitbook.io/docs/flutter-sdk/integration)
- [Unity](https://pub-star.gitbook.io/docs/unity-sdk/integration)

The SDK provides a unified and flexible API for loading, displaying, and managing ads while ensuring a non-intrusive and optimized user experience.

> **Current version:** `1.6.0`

### Supported Ad Formats

PubStar supports the following ad formats:

- Banner Ads
- Native Ads
- Interstitial Ads
- App Open Ads
- Rewarded Ad
- Video Ads (IMA)

All formats are responsive and optimized for performance and revenue maximization.

## Requirements

- Min Dart SDK >= **3.7**
- iOS >= **13.0**
- Android `minSdk` >= **23**
- A **PubStar App ID** from the PubStar Dashboard (format `pub-app-id-XXXX`)

## Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  pubstar_io: ^1.6.0
```

Then run:

```bash
flutter pub get
```

Add your PubStar App ID:

- **Android** — in `AndroidManifest.xml`, inside `<application>`:

```xml
<meta-data
  android:name="io.pubstar.key"
  android:value="pub-app-id-XXXX" />
```

- **iOS** — in `Info.plist`:

```xml
<key>io.pubstar.key</key>
<string>pub-app-id-XXXX</string>
```

> Replace `pub-app-id-XXXX` with your real App ID (for example `pub-app-id-1233`). Do not ship production builds with a placeholder value.

## Usage

### Init SDK

Initialization must be called once before loading or showing ads.

```dart
import 'package:pubstar_io/pubstar_io.dart';

try {
    await PubstarIo.init();
    // ready to load and show ads
} on PubstarIoException catch (e) {
    // init error
}
```

### Load AD

```dart
PubstarIo.loadAd(
  adId,
  LoadListener(
    onLoaded: () { /* ad loaded */ },
    onError: (error) { /* ad load error */ },
  ),
);
```

### Show AD

```dart
PubstarIo.showAd(
  adId,
  ShowListener(
    onShowed: () { /* ad showed */ },
    onHide: (reward) { /* ad hidden, optional reward */ },
    onError: (error) { /* error */ },
  ),
);
```

### Load And Show AD

```dart
PubstarIo.loadAndShow(
  adId,
  LoadAndShowNoViewListener(
    onLoaded: () { /* ad loaded */ },
    onShowed: () { /* ad showed */ },
    onHide: (reward) { /* ad hidden, optional reward */ },
    onError: (error) { /* error */ },
  ),
);
```

### Banner & Native

Use `PubstarAdView` for view-based formats (`banner`, `native`):

```dart
PubstarAdView(
  adId: adId,
  size: PubstarAdSize.medium, // small, medium, big
  type: PubstarAdType.native, // banner or native
  mode: PubstarAdViewMode.loadAndShow,
  onLoaded: () { /* ad loaded */ },
  onShowed: () { /* ad showed */ },
  onHide: (reward) { /* ad hidden, optional reward */ },
  onError: (error) { /* error */ },
)
```

### Custom Native — your own layout

Beyond the preset sizes, you can render a native ad with **your own layout**. Design the layout natively (Android XML / iOS view), then map your view IDs to the ad fields with a `PubstarNativeCustomConfig` and pass it via `nativeCustomConfig`.

```dart
import 'dart:io';

final customConfig = Platform.isAndroid
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

PubstarAdView(
  adId: adId,
  type: PubstarAdType.native,
  nativeCustomConfig: customConfig,
  onLoaded: () { /* ad loaded */ },
  onShowed: () { /* ad showed */ },
  onHide: (reward) { /* ad hidden */ },
  onError: (error) { /* error */ },
)
```

> `nativeCustomConfig` is only applied when `type: PubstarAdType.native`. The view IDs and `layoutName` must match native resources defined in your host app. The **media** view must be a container/`ViewGroup` — the SDK injects the network's media view into it.

### Video (IMA)

Use `PubstarVideoAdView` with a required `type` (`inStream` / `outStream`):

```dart
PubstarVideoAdView(
  adId: adId,
  media: 'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
  type: PubStarVideoAdType.outStream, // outStream or inStream
  onLoaded: () { /* ad loaded */ },
  onShowed: () { /* ad showed */ },
  onHide: (reward) { /* ad hidden */ },
  onError: (error) { /* error */ },
)
```

- `outStream`: a standalone video ad placed in your layout.
- `inStream`: the ad plays inside your own video content stream (`media`).

## ID Test AD

Pair these with App ID `pub-app-id-1233`. Replace them with production placement keys before shipping.

```text
App ID          : pub-app-id-1233
Banner ID       : 1233/99228313580
Native ID       : 1233/99228313581
Interstitial ID : 1233/99228313582
Open ID         : 1233/99228313583
Rewarded ID     : 1233/99228313584
Video ID        : 1233/99228313585
```

### Documentation

[**Guides**](https://pub-star.gitbook.io/docs/)

### Support

[Support](https://pub-star.gitbook.io/docs/support)

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
