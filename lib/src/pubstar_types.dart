enum PubstarAdEvent { loaded, showed, hide, error, done }

class PubstarError {
  final int? code;
  final String? name;
  final String? message;
  const PubstarError({this.code, this.name, this.message});

  static PubstarError fromMap(Map<String, dynamic> map) {
    return PubstarError(
      code: (map['code'] as int).toInt(),
      name: map['name'] as String,
      message: map['message'] as String,
    );
  }
}

class PubstarReward {
  final String? type;
  final int? amount;
  const PubstarReward({this.type, this.amount});

  static PubstarReward? fromMap(Map<String, dynamic> map) {
    if (map.containsKey('type') && map.containsKey('amount')) {
      return PubstarReward(
        type: map['type'] as String,
        amount: (map['amount'] as int).toInt(),
      );
    }

    return null;
  }
}

typedef OnLoaded = void Function();
typedef OnLoadedError = void Function();
typedef OnShowed = void Function();
typedef OnShowedError = void Function();
typedef OnHide = void Function(PubstarReward? reward);
typedef OnError = void Function(PubstarError error);
typedef OnDone = void Function();
typedef OnInit = void Function();

/// Configuration for rendering custom native ad layouts.
///
/// Resource names are resolved on Android from the host app package.
class PubstarNativeCustomConfig {
  const PubstarNativeCustomConfig({
    required this.layoutName,
    this.advertiserTextViewId,
    this.iconImageViewId,
    this.titleTextViewId,
    this.mediaContentViewGroupId,
    this.bodyTextViewId,
    this.callToActionButtonId,
    this.loadingViewId,
    this.ctaColorHex,
  });

  final String layoutName;
  final String? advertiserTextViewId;
  final String? iconImageViewId;
  final String? titleTextViewId;
  final String? mediaContentViewGroupId;
  final String? bodyTextViewId;
  final String? callToActionButtonId;
  final String? loadingViewId;
  final String? ctaColorHex;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'layoutName': layoutName,
      'advertiserTextViewId': advertiserTextViewId,
      'iconImageViewId': iconImageViewId,
      'titleTextViewId': titleTextViewId,
      'mediaContentViewGroupId': mediaContentViewGroupId,
      'bodyTextViewId': bodyTextViewId,
      'callToActionButtonId': callToActionButtonId,
      'loadingViewId': loadingViewId,
      'ctaColorHex': ctaColorHex,
    };
  }
}

sealed class PubstarListener {
  final OnError? onError;
  const PubstarListener({this.onError});

  bool shouldRemove(String event);
}

class InitListener extends PubstarListener {
  final OnInit? onInit;
  InitListener({this.onInit, super.onError});

  @override
  bool shouldRemove(String event) => event == 'INIT' || event == 'ERROR';
}

class LoadListener extends PubstarListener {
  final OnLoaded? onLoaded;
  LoadListener({this.onLoaded, super.onError});

  @override
  bool shouldRemove(String event) => event == 'LOADED' || event == 'ERROR';
}

class ShowListener extends PubstarListener {
  final OnHide? onHide;
  final OnShowed? onShowed;
  ShowListener({this.onHide, this.onShowed, super.onError});

  @override
  bool shouldRemove(String event) => event == 'HIDE' || event == 'ERROR';
}

class LoadAndShowListener extends PubstarListener {
  final OnLoaded? onLoaded;
  final OnHide? onHide;
  final OnShowed? onShowed;

  LoadAndShowListener({
    this.onLoaded,
    super.onError,
    this.onHide,
    this.onShowed,
  });

  @override
  bool shouldRemove(String event) => event == 'SHOWED' || event == 'ERROR';
}

class LoadAndShowNoViewListener extends PubstarListener {
  final OnLoaded? onLoaded;
  final OnHide? onHide;
  final OnShowed? onShowed;

  LoadAndShowNoViewListener({
    this.onLoaded,
    super.onError,
    this.onHide,
    this.onShowed,
  });

  @override
  bool shouldRemove(String event) => event == 'HIDE' || event == 'ERROR';
}
