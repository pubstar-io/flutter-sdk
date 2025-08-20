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
