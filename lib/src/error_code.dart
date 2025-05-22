enum ErrorCode {
  loadedError,
  showError,
  notSupportAdFormat,
  initError,
  noAd,
  noViewToAttach,
  noInit,
  rejectByFrequency,
  changeFrequency,
  unknown,
}

class ErrorCodeUtil {
  static ErrorCode errorCodeFromNative(String nativeValue) {
    switch (nativeValue) {
      case "LOADED_ERROR":
        return ErrorCode.loadedError;
      case "SHOW_ERROR":
        return ErrorCode.showError;
      case "NOT_SUPPORT_AD_FORMAT":
        return ErrorCode.notSupportAdFormat;
      case "INIT_ERROR":
        return ErrorCode.initError;
      case "NO_AD":
        return ErrorCode.noAd;
      case "NO_VIEW_TO_ATTACH":
        return ErrorCode.noViewToAttach;
      case "NO_INIT":
        return ErrorCode.noInit;
      case "REJECT_BY_FREQUENCY":
        return ErrorCode.rejectByFrequency;
      case "CHANGE_FREQUENCY":
        return ErrorCode.changeFrequency;
      default:
        return ErrorCode.unknown;
    }
  }
}
