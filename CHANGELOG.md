## [1.1.8] - 2025-05-25

### Added
- **First public release of `pubstar_io` Flutter plugin.**
- Supports both **Android** and **iOS** platforms.
- Display mobile ads using Pubstar Ads API on Android/iOS devices.
- Core API:
  - `PubstarIo.instance.init()`: Initialize the Pubstar IO Ads SDK.
  - `PubstarIo.instance.loadAd(String adId)`: Load an ad by ID.
  - `PubstarIo.instance.showAd({required String adId})`: Show an ad once by ID.
  - `PubstarIo.instance.showAdWithViewId({required String adId, required int viewId})`: Show ad in a specific native view.
  - `PubstarIo.instance.loadAndShowAd(String adId)`: Load and immediately show an ad.
  - `PubstarIo.instance.loadAndShowAdWithViewId({required String adId, required int viewId})`: Load and show an ad in a specific view.
- **Flutter widget**:  
  - `PubstarAdView`: Easily embed native ad views in your widget tree.
  - Supports different ad loading/display modes via `PubstarAdViewMode`.
- **Ad event stream**:  
  - `PubstarAdEventStream.stream`: Listen to ad events (`AdLoaded`, `AdShowed`, `AdHide`, `AdError`) from native via EventChannel.
  - Typed ad event classes for type-safe event handling.
- **Error code utilities**:
  - `ErrorCode` enum for handling common ad-related errors.

### Notes
- Please call `PubstarIo.instance.init()` before loading or showing any ads.
- Requires valid Pubstar Ads API key/ad unit IDs for proper operation.
- See documentation and inline comments for usage examples.


