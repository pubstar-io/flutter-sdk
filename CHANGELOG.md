## [1.3.2] - 2025-12-19

### Added
- **Prebid Mediation**
  - Added mediation support between Prebid and Google AdMob, AppLovin MAX, and Google Ad Manager (GAM).
  - Enables Prebid demand to compete in the mediation stack for supported formats without additional integration work.
  - Configuration is handled at the Pubstar level so existing placements can be upgraded to Prebid Mediation with minimal changes.

## [1.3.1] - 2025-11-28

### Changed
- **Reduced overall SDK size**  
  - Optimized internal architecture to significantly reduce the plugin size on both Android and iOS.
- **Faster initialization performance (`init()`)**  
  - Improved startup flow and asynchronous handling, resulting in faster SDK initialization.
- **Improved ad loading speed**  
  - Enhanced the ad loading pipeline, reducing latency and increasing load stability.
- **Enhanced modularity for future ad network integrations**  
  - Refactored core structure to make it easier to extend and integrate additional ad networks in upcoming versions.

### Notes
- No API changes are required when upgrading to 1.3.1.
- Recommended update for better performance and long-term support.

## [1.1.8+2] - 2025-05-25

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
- **Flutter widget**:  
  - `PubstarAdView`: Easily embed native ad views in your widget tree.
  - `PubstarAdVideoView`: Easily embed native video ad views in your widget tree.
  - Supports different ad loading/display modes via `PubstarAdViewMode`.
- **Ad event stream**:  
  - `PubstarEventService`: Listen to ad events (`AdLoaded`, `AdShowed`, `AdHide`, `AdError`) from native via EventChannel.
  - Typed ad event classes for type-safe event handling.

### Notes
- Please call `PubstarIo.instance.init()` before loading or showing any ads.
- Requires valid Pubstar Ads API key/ad unit IDs for proper operation.
- See documentation and inline comments for usage examples.

## [1.1.8+3] - 2025-08-21

### Added
- **New example Ads IDs** via `AdIdExample` class:
  - `bannerId`, `nativeId`, `interstitialId`, `openId`, `rewardedId`, `videoId`
- **Controller utilities** to demonstrate usage:
  - `Pubstar.init()`: Initialize SDK with preload ad examples.
  - `loadAd(String adId)`: Load an ad by ID with `LoadListener`.
  - `showAd(String adId)`: Show an ad by ID with `ShowListener`.
  - `loadAndShow(String adId)`: Load and immediately show an ad by ID with `LoadAndShowNoViewListener`.
- **Improved ad lifecycle callbacks**:
  - `onLoaded`: Called when ad successfully loaded.
  - `onShowed`: Called when ad displayed.
  - `onHide`: Called when ad hidden/closed (supports rewarded ads). Returns detailed `PubstarReward` object (`type`, `amount`).
  - `onError`: Returns detailed `PubstarError` object (`code`, `name`, `message`).
- **New Listener classes** for flexible event handling:
  - `LoadListener`: For handling ad load-only scenarios (before showing).
  - `ShowListener`: For ads that are already preloaded and then shown.
  - `LoadAndShowNoViewListener`: For loading and showing ads without attaching to a native view.
  - `LoadAndShowListener`: For handling ad load + show in a native view (e.g., `PubstarAdView`).

### Changed
- Updated `PubstarAdView` widget:
  - Added detailed **callback documentation** for `onError`, `onLoaded`, `onHide`, `onShowed`.
  - Clearer usage notes for different ad display modes (`onlyShow` vs `loadAndShow`).
- More structured example logging in Flutter for debugging lifecycle events.

### Notes
- Please ensure you call `PubstarIo.init()` before loading or showing ads.
- Reward callbacks (`onHide`) now return optional reward info (`type`, `amount`) for rewarded ads.