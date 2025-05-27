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

# 1. Configure Maven Repositories
Open your project-level build.gradle or settings.gradle and add:
```bash
repositories {
  mavenCentral()
  maven { url = uri("https://artifactory.appodeal.com/appodeal") }  <--- add this
}
```

# 2. Add Pubstar Key to AndroidManifest.
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
```
import 'package:pubstar_io/pubstar_io.dart';

void main() async {
  await PubstarIo.instance.init();  <---

  runApp(MyApp());
}
```

### Load & Show an Ad
```
await PubstarIo.instance.loadAd('your_ad_id');
await PubstarIo.instance.showAd(adId: 'your_ad_id');
```

### Show Ad in a Native View (Recommended)
```
PubstarAdView(adId: 'your_ad_id');
```

### Listen to Ad Events
```
import 'package:pubstar_io/pubstar_io.dart';

PubstarAdEventStream.stream.listen((event) {
  switch (event) {
    case AdLoaded():
      print('Ad loaded: ${event.adId}');
      break;
    case AdShowed():
      print('Ad shown: ${event.adId}');
      break;
    case AdHide():
      print('Ad closed: ${event.adId}');
      break;
    case AdError():
      print('Ad error: ${event.adId}, ${event.error}');
      break;
    case UnknownEvent():
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