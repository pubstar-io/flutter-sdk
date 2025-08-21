# Pubstar

[![pub.dev](https://img.shields.io/pub/v/pubstar.svg)](https://pub.dev/packages/pubstar_io)

PubStar Flutter Mobile AD SDK is a comprehensive software development kit designed to empower developers with robust tools and functionalities for integrating advertisements seamlessly into Flutter mobile applications. Whether you're a seasoned developer or a newcomer to the world of app monetization, our SDK offers a user-friendly solution to maximize revenue streams while ensuring a non-intrusive and engaging user experience.

## TOC

- [Features](#features)
- [Platform Support](#platform-support)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API](#api)
- [Release Notes](#release-notes)
- [ID Test Ad](#id-test-ad)
- [Support](#support)


## Features

- ✅ **Display native ads** on Android & iOS with Pubstar API.
- ✅ Full-featured API: load, show, loadAndShow, and handle ad events.
- ✅ Easy-to-use Flutter widget: `PubstarAdView` and `PubstarVideoAdView`.
- ✅ Structured ad event callback for type-safe event handling.


## Platform Support

| Android | iOS |
|---------|-----|
| ✔       | ✔   |


## Requirements

- iOS >= 13.0
- Min Dart SDK >= 3.7


## Installation

Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  pubstar_io
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
  await PubstarIo.init();  <--- init Pubstar

  runApp(MyApp());
}
```


## API

The example app in this repository shows an example usage of every single API, consult the example app if you have questions, and if you think you see a problem make sure you can reproduce it using the example app before reporting it, thank you.

| Method                                                              | Return Type         |
| ------------------------------------------------------------------- | ------------------- |
| [init()](#init)                                                     | `Future<void>`      |
| [loadAd()](#loadad)                                                 | `Function<void>`    |
| [showAd()](#showad)                                                 | `Function<void>`    |
| [loadAndShow()](#loadandshow)                                       | `Function<void>`    |
| [PubstarAdView](#pubstaradview)                                     | `Widget`            |
| [PubstarVideoAdView](#pubstarvideoadview)                           | `Widget`            |

### init()

Initialization Pubstar SDK.

```dart
Pubstar.init();
```

### loadAd()

Load Pubstar ads by adId to application.

#### Event

`LoadListener`

| Callback                             | Function                                                      |
| ------------------------------------ | ------------------------------------------------------------- |
| `onError`                            | call when load ad failed. return object type `PubstarError`   |
| `onLoaded`                           | call when ad loaded                                           |

#### Example

```dart
PubstarIo.loadAd(
  adId,
  LoadListener(
    onLoaded: () => print("FLUTTER - app: onLoaded loadAd"),
    onError:
        (error) => print(
          "FLUTTER - app: onError loadAd, code: ${error.code} - rawCode: ${error.name}",
        ),
  ),
);
```


### showAd()

Show ad had loaded before.

#### Event

`LoadListener`

| Callback             | Function                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------ |
| `onHide`             | call when ad hidden by press close button. return **optional** object type `PubstarReward` |
| `onShowed`           | call when ad showed                                                                        |
| `onError`            | call when show ad failed. return object type `PubstarError`                                |

#### Example

```dart
PubstarIo.showAd(
  adId,
  ShowListener(
    onShowed: () => print("FLUTTER - app: onShowed showAd"),
    onHide:
        (reward) => print(
          "FLUTTER - app: onHide showAd  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
        ),
    onError:
        (error) => print(
          "FLUTTER - app: onError showAd, code: ${error.code} - name: ${error.name} - message: ${error.message}",
        ),
  ),
);
```


### loadAndShow()

Load ad then show ad in one.

#### Event

`LoadAndShowNoViewListener`

| Callback             | Function                                                                                   |
| -------------------- | -------------------------------------------------------------------------------------------|
| `onLoaded`           | call when ad loaded                                                                        |
| `onShowed`           | call when ad showed                                                                        |
| `onHide`             | call when ad hidden by press close button. return **optional** object type `PubstarReward` |
| `onError`            | call when show ad failed. return object type `PubstarError`                                |

#### Example

```dart
PubstarIo.loadAndShow(
  adId,
  LoadAndShowNoViewListener(
    onError:
        (error) => print(
          "FLUTTER - app: onError loadAndShow, code: ${error.code} - rawCode: ${error.name}",
        ),
    onHide:
        (reward) => print(
          "FLUTTER - app: onHide loadAndShow  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
        ),
    onLoaded: () => print("FLUTTER - app: onLoaded loadAndShow"),
    onShowed: () => print("FLUTTER - app: onShowed loadAndShow"),
  ),
);
```


### PubstarAdView

Load ad then show ad, using for Banner ad and Native ad.

#### API

| Props                   | Function                                                                       |
| ----------------------- | ------------------------------------------------------------------------------ |
| `adId`                  | id of Banner or Native ad                                                      |
| `size`                  | size of ad View. (`small`, `medium`, `large`)                                  |
| `type`                  | type of ad View. (`banner`, `native`)                                          |
| `mode`                  | mode of ad View (`onlyShow`, `loadAndShow`)                                    |
| `onError`               | call when show ad failed. return object type `PubstarError`                    |
| `onHide`                | call when ad closed return **optional** object type `PubstarReward`            |
| `onLoaded`              | call when ad loaded                                                            |
| `onShowed`              | call when ad showed                                                            |

#### Example

```dart
PubstarAdView(
  adId: adId,
  size: PubstarAdSize.small,
  type: PubstarAdType.banner,
  mode: PubstarAdViewMode.loadAndShow,
  onError:
      (error) => print(
        "FLUTTER - app: onError banner, code: ${error.code} - rawCode: ${error.name}",
      ),
  onHide:
      (reward) => print(
        "FLUTTER - app: onHide banner  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
      ),
  onLoaded: () => print("FLUTTER - app: onLoaded banner"),
  onShowed: () => print("FLUTTER - app: onShowed banner"),
)
```

### PubstarVideoAdView

Load video ad then show video ad, using for Video ad.

#### API

| Props                   | Function                                                                       |
| ----------------------- | ------------------------------------------------------------------------------ |
| `adId`                  | id of Video ad                                                      |
| `media`                 | url of media video                                    |
| `onError`               | call when show ad failed. return object type `PubstarError`                    |
| `onHide`                | call when ad closed return **optional** object type `PubstarReward`            |
| `onLoaded`              | call when ad loaded                                                            |
| `onShowed`              | call when ad showed                                                            |

#### Example

```dart
PubstarVideoAdView(
  adId: adId,
  media:
      'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
  onError:
      (error) => print(
        "FLUTTER - app: onError video, code: ${error.code} - rawCode: ${error.name}",
      ),
  onHide:
      (reward) => print(
        "FLUTTER - app: onHide video  - type: ${reward?.type ?? ""} - amount: ${reward?.amount ?? 0}",
      ),
  onLoaded: () => print("FLUTTER - app: onLoaded video"),
  onShowed: () => print("FLUTTER - app: onShowed video"),
)
```


## Release Notes

See the [CHANGELOG.md](https://github.com/pubstar-io/flutter-sdk/blob/main/CHANGELOG.md).

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