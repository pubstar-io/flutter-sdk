# Pubstar

[![pub.dev](https://img.shields.io/pub/v/pubstar.svg)](https://pub.dev/packages/pubstar_io)

PubStar Flutter Mobile AD SDK is a comprehensive software development kit designed to empower developers with robust tools and functionalities for integrating advertisements seamlessly into Flutter mobile applications. Whether you're a seasoned developer or a newcomer to the world of app monetization, our SDK offers a user-friendly solution to maximize revenue streams while ensuring a non-intrusive and engaging user experience.

---

## Features

- ✅ **Display native ads** on Android & iOS with Pubstar API.
- ✅ Full-featured API: load, show, and handle ad events.
- ✅ Easy-to-use Flutter widget: `PubstarAdView` and `PubstarVideoAdView`.
- ✅ Structured ad event stream for type-safe event handling.

---

## Platform Support

| Android | iOS |
|---------|-----|
| ✔       | ✔   |

---

## Requirements

- iOS >= 12.0

## Getting Started

### 1. Installation

Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  pubstar_io: ^1.1.8
```

Then run:

```bash
flutter pub get
```

## Configuration

### iOS

#### 1. Configure Pod.
1. Navigate to your iOS project directory.

2. Install the dependencies using pod install.

```bash
pod install
```

3. Open your project in Xcode with the .xcworkspace file.

#### 2. Update your Info.plist

Update your app's Info.plist file to add two keys:

A GADApplicationIdentifier key with a string value of your AdMob app ID [found in the AdMob UI](https://support.google.com/admob/answer/7356431).

```xml
<key>GADApplicationIdentifier</key>
<string>Your AdMob app ID</string>
<key>NSUserTrackingUsageDescription</key>
<string>We use your data to show personalized ads and improve your experience.</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Android

#### 1. Configure Maven Repositories
Open your project-level build.gradle or settings.gradle and add:
```gradle
repositories {
  mavenCentral()
  maven { url = uri("https://artifactory.appodeal.com/appodeal") }  <--- add this
}
```

#### 2. Add Pubstar Key to AndroidManifest.
Open `AndroidManifest.xml` and add inside `<application>`:

```bash
<meta-data
  android:name="io.pubstar.key"
  android:value="pub-app-id-XXXX" />
```
Replace pub-app-id-XXXX with your actual [Pubstar App ID](https://pubstar.io/).  

## Usage

### Initialize the SDK
Initializes the Pubstar IO Ads SDK.

Must be called **once** before loading or showing any ad.

```dart
import 'package:pubstar_io/pubstar_io.dart';

void main() async {
  await PubstarIo.instance.init();  <--- init Pubstar

  runApp(MyApp());
}
```

### Load & Show an Ad

Loads an ad with the given `ad_id`.

```dart
await PubstarIo.instance.loadAd('your_ad_id');
await PubstarIo.instance.showAd('your_ad_id');
await PubstarIo.instance.loadAndShowAd('your_ad_id');
```

### Show Ad in a Native View (Recommended)

A Flutter widget for displaying a native ad view using Pubstar IO plugin.

#### Usage notes:
- You must call `PubstarIo.instance.init()` before using this widget.
- The `ad_id` parameter must be a valid ad unit ID from your ad provider.
- Place this widget inside your widget tree where you want the ad to appear.
- Handles lifecycle and automatically calls `showAdWithViewId`.
- The `type` parameter allows you to specify the ad type (Banner or Video).
- The `size` parameter allows you to specify the ad size (Small, Medium, Large, Collapsible).
- The `isAllowLoadNext` parameter allows load to cache after dismiss.
- The `media` parameter is specify the Video URL.

```dart
/// Only show ad when the view is loaded.
///
/// You must call PubstarIo.instance.loadAd before using this.
PubstarAdView(adId: 'your_ad_id');

/// Load ad first, then show when ready.
PubstarAdView(
  adId: 'your_ad_id', 
  mode: PubstarAdViewMode.loadAndShow,
  type: PubstarAdType.native,
  size: PubstarAdSize.small,
  isAllowLoadNext: true,
)

/// Load and show a video ad.
PubstarVideoAdView(
  adId: AdIdExample.videoId,
  media:
      'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
)
```

### Listen to Ad Events
Listen all possible ad events emitted by the Pubstar IO Ads plugin.

```dart
class _MyAppState extends State<MyApp> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = PubstarEventService().listen((data) {
      print('Event from native: $data');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }
}
```

## API Reference
Check the main exported classes:
- PubstarIo (singleton for core ad operations)

- PubstarAdView (Flutter widget for ad views)

- PubstarAdVideo (Flutter widget for ad videos)

- PubstarEventService (ad event listener)

## ID Test AD

```python
App ID : pub-app-id-1233
Banner Id : 1233/99228313580
Native ID : 1233/99228313581
Interstitial ID : 1233/99228313582
Open ID : 1233/99228313583
Rewarded ID : 1233/99228313584
Video ID : 1233/99228313585
```

## Support
Email: developer@tqcsolution.com

Raise an issue on GitHub for bugs or feature requests.

## License

Pubstar is released under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/).

License agreement is available at [LICENSE](LICENSE).