# pubstar_io

[![pub.dev](https://img.shields.io/pub/v/pubstar_io.svg)](https://pub.dev/packages/pubstar_io)

A Flutter plugin to display ads on Android and iOS devices using the [Pubstar Ads API](https://pubstar.io/).  
Supports embedding native ad views, loading/showing ads by ad ID, and listening to ad events for full control.

---

## Features

- ✅ **Display native ads** on Android & iOS with Pubstar API.
- ✅ Full-featured API: load, show, and handle ad events.
- ✅ Easy-to-use Flutter widget: `PubstarAdView`.
- ✅ Structured ad event stream for type-safe event handling.

---

## Platform Support

| Android | iOS |
|---------|-----|
| ✔       | ✔   |

---

## Getting Started

### 1. Installation

Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  pubstar_io: ^1.1.8
```

Then run:

`flutter pub get`

## Configuration

### Android

### 1. Configure Maven Repositories
Open your project-level build.gradle or settings.gradle and add:
```bash
repositories {
  mavenCentral()
  maven { url = uri("https://artifactory.appodeal.com/appodeal") }  <--- add this
}
```

### 2. Add Pubstar Key to AndroidManifest.
Open `android/app/src/main/AndroidManifest.xml` and add inside `<application>`:

```bash
<meta-data
  android:name="io.pubstar.key"
  android:value="pub-app-id-XXXX" />
```
Replace pub-app-id-XXXX with your actual Pubstar App ID.

### iOS
No additional setup required (plugin will handle integration automatically).


## Usage

### Initialize the SDK
Initializes the Pubstar IO Ads SDK.

Must be called **once** before loading or showing any ad.

```
import 'package:pubstar_io/pubstar_io.dart';

void main() async {
  await PubstarIo.instance.init();  <---

  runApp(MyApp());
}
```

### Load & Show an Ad

Loads an ad with the given `ad_id`.

```
await PubstarIo.instance.loadAd('your_ad_id');
await PubstarIo.instance.showAd(adId: 'your_ad_id');
```

### Show Ad in a Native View (Recommended)

A Flutter widget for displaying a native ad view using Pubstar IO plugin.

#### Usage notes:
- You must call `PubstarIo.instance.init()` before using this widget.
- The `ad_id` parameter must be a valid ad unit ID from your ad provider.
- Place this widget inside your widget tree where you want the ad to appear.
- Handles lifecycle and automatically calls `showAdWithViewId`.

```
/// Only show ad when the view is loaded.
///
/// You must call `PubstarIo.instance.loadAd` before using this.
PubstarAdView(adId: 'your_ad_id');

/// Load ad first, then show when ready.
PubstarAdView(adId: 'your_ad_id', mode: PubstarAdViewMode.loadAndShow)
```

### Listen to Ad Events
Listen all possible ad events emitted by the Pubstar IO Ads plugin.

```
import 'package:pubstar_io/pubstar_io.dart';

PubstarAdEventStream.stream.listen((event) {
  switch (event) {
    case AdLoaded(): // Event emitted when an ad is successfully loaded and ready to be shown.
      print('Ad loaded: ${event.adId}');
      break;
    case AdShowed(): // Event emitted when an ad is successfully shown.
      print('Ad shown: ${event.adId}');
      break;
    case AdHide(): // Event emitted when an ad is hidden, dismissed, or closed.
      print('Ad closed: ${event.adId}');
      break;
    case AdError(): // Event emitted when there is an error loading or showing an ad.
      print('Ad error: ${event.adId}, ${event.error}');
      break;
    case UnknownEvent(): // Event emitted when an unknown or unhandled event type is received from native.
      print('Unknown event received');
      break;
  }
});
```

## API Reference
Check the main exported classes:
- PubstarIo (singleton for core ad operations)

- PubstarAdView (Flutter widget for ad views)

- PubstarAdEventStream (ad event listener)

- ErrorCode (enum for error handling)

## Support
- Email: developer@tqcsolution.com
- Raise an issue on GitHub for bugs or feature requests.