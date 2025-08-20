import Flutter
import UIKit
import AVFoundation
import Pubstar

enum PubstarAdEvent: Int {
    case LOADED
    case SHOWED
    case HIDE
    case ERROR
}

class PubstarEventStreamHandler: NSObject, FlutterStreamHandler {
    static let shared = PubstarEventStreamHandler()

    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    private func sendEvent(_ event: Any) {
        eventSink?(event)
    }
    
    func sendAdEvent(event: PubstarAdEvent, adId: String, data: [String: Any]? = nil) {
        var eventData: [String: Any] = [
            "event": "\(event)",
            "adId": adId
        ]

        if let data = data {
            for (key, value) in data {
                eventData[key] = value
            }
        }
        
        self.sendEvent(eventData)
    }
}

extension FlutterMethodCall {
    func extractAdId(result: @escaping FlutterResult) -> String? {
        guard let args = self.arguments as? [String: Any],
              let adId = args["adId"] as? String else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing or invalid 'adId'",
                    details: nil
                )
            )
            return nil
        }
        
        if adId.isEmpty {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "AdId is empty String",
                    details: nil
                )
            )
            return nil
        }
        
        return adId
    }
    
    func extractCallbackIdId(result: @escaping FlutterResult) -> String? {
        guard let args = self.arguments as? [String: Any],
              let callbackId = args["callbackId"] as? String else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing or invalid 'adId'",
                    details: nil
                )
            )
            return nil
        }
        
        if callbackId.isEmpty {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "AdId is empty String",
                    details: nil
                )
            )
            return nil
        }
        
        return callbackId
    }
    
    func extractViewId(result: @escaping FlutterResult) -> Int64? {
        guard
            let args = self.arguments as? [String: Any],
            let viewId = args["viewId"] as? Int64
        else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing viewId",
                    details: nil
                )
            )
            return nil
        }
        
        return viewId
    }
    
    func extractNativeSize(result: @escaping FlutterResult) -> NativeAdRequest.TypeSize {
        guard
            let args = self.arguments as? [String: Any],
            let size = args["typeSize"] as? String
        else {
            return .Small
        }
        
        switch size {
        case "small":
            return .Small
        case "medium":
            return .Medium
        case "big":
            return .Big
        default:
            return .Small
        }
    }
    
    func extractBannerSize(result: @escaping FlutterResult) -> BannerAdRequest.AdTag {
        guard
            let args = self.arguments as? [String: Any],
            let tag = args["tag"] as? String
        else {
            return .small
        }
        
        switch tag {
        case "small":
            return .small
        case "medium":
            return .medium
        case "big":
            return .big
        case "collapsible":
            return .collapsible
        default:
            return .small
        }
    }
    
    func extractIsAllowLoadNext(result: @escaping FlutterResult) -> Bool {
        guard
            let args = self.arguments as? [String: Any],
            let isAllowLoadNext = args["isAllowLoadNext"] as? Bool
        else {
            return true
        }
        
        return isAllowLoadNext
    }
    
    func extractMedia(result: @escaping FlutterResult) -> String? {
        guard
            let args = self.arguments as? [String: Any],
            let media = args["media"] as? String
        else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENT",
                    message: "Missing media",
                    details: nil
                )
            )
            return nil
        }
        
        return media
    }
}

@available(iOS 13.0, *)
public class PubstarIoPlugin: NSObject, FlutterPlugin {
    private static let methodChanelName = "pubstar_io"
    private let methodChannelCallback = "pubstar_io#callback"
    private static let eventChanelName = "pubstar_io_event"
    private static let nativeViewId = "pubstar_ad_view"
    private var channel: FlutterMethodChannel?
    
    private static func registerMethodChanel(registrar: FlutterPluginRegistrar) {
        let instance = PubstarIoPlugin()
        let channel = FlutterMethodChannel(name: methodChanelName, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.channel = channel
    }
    
    private static func registerEventChanel(registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(name: eventChanelName, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(PubstarEventStreamHandler.shared)
    }
    
    private static func registerNativeView(registrar: FlutterPluginRegistrar) {
        registrar.register(NativeViewFactory(), withId: nativeViewId)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        registerMethodChanel(registrar: registrar)

        registerEventChanel(registrar: registrar)

        registerNativeView(registrar: registrar)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let channel = self.channel else {
            result(FlutterError(code: "\(ErrorCode.NO_INIT.rawValue)", message: "Channel not initialized", details: nil))
           return
       }
        
        func onErrorCallback(callbackId: String, message: String = "Pubstar is error") -> (ErrorCode) -> Void {
            return { errorCode in
                print("onErrorCallback - errorCode: \(errorCode) - error: \(errorCode.rawValue)")
                channel.invokeMethod(
                    self.methodChannelCallback,
                    arguments: [
                        "cbId": callbackId,
                        "event": "\(PubstarAdEvent.ERROR)",
                        "code": "code",
                        "name": "name",
                        "message": message
                    ]
                )
            }
        }
        
        func onAdHideCallback(callbackId: String) -> (RewardModel?) -> Void {
            return { _ in
                channel.invokeMethod(
                    self.methodChannelCallback,
                    arguments: [
                        "cbId": callbackId,
                        "event": "\(PubstarAdEvent.HIDE)"
                    ]
                )
            }
        }
        
        func onAdShowedCallback(callbackId: String) -> () -> Void {
            return {
                channel.invokeMethod(
                    self.methodChannelCallback,
                    arguments: [
                        "cbId": callbackId,
                        "event": "\(PubstarAdEvent.SHOWED)"
                    ]
                )
            }
        }
        
        func onAdLoadedCallback(callbackId: String) -> () -> Void {
            return {
                channel.invokeMethod(
                    self.methodChannelCallback,
                    arguments: [
                        "cbId": callbackId,
                        "event": "\(PubstarAdEvent.LOADED)"
                    ]
                )
            }
        }
        
        func onInitDoneCallback() -> () -> Void {
            return {
                result(true)
            }
        }
        
        func onInitErrorCallback() -> (ErrorCode) -> Void {
            return { errorCode in
                result(
                    FlutterError(
                        code: "\(errorCode)",
                        message: "Pubstar initialization failed.",
                        details: [
                            "errorCode": "\(errorCode)",
                            "errorRawValue": "\(errorCode.rawValue)"
                        ]
                    )
                )
            }
        }
        
        switch call.method {
        case "init":
            PubstarAdManagerWrapper.initPubstar(
                onDone: onInitDoneCallback(),
                onError: onInitErrorCallback()
            )
        case "loadAd":
            guard let adId = call.extractAdId(result: result) else {
                return
            }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            PubstarAdManagerWrapper.loadAd(
                adId: adId,
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onError: onErrorCallback(callbackId: callbackId, message: "loadAd is failed.")
            )
        case "showAd":
            guard let adId = call.extractAdId(result: result) else {
                return
            }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            PubstarAdManagerWrapper.showAd(
                adId: adId,
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onError: onErrorCallback(callbackId: callbackId, message: "showAd is failed.")
            )
        case "showAdWithViewId":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let viewId = call.extractViewId(result: result) else { return }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            guard let adView = PubstarAdViewRegistry.shared.views[viewId] else {
                result(
                    FlutterError(
                        code: "NO_VIEW_TO_ATTACH",
                        message: "AdView is not exist",
                        details: nil
                    )
                )
                return
            }
            
            PubstarAdManagerWrapper.showAd(
                adId: adId,
                view: adView,
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onError: onErrorCallback(callbackId: callbackId, message: "showedAd is failed.")
            )
        case "loadAndShowAd":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            PubstarAdManagerWrapper.loadAndShowAd(
                adId: adId,
                onLoaderError: onErrorCallback(callbackId: callbackId, message: "onAdLoader is failed."),
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onShowedError: onErrorCallback(callbackId: callbackId, message: "onShowed is failed."),
            )
        case "loadAndShowAdWithViewId":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let viewId = call.extractViewId(result: result) else { return }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            guard let adView = PubstarAdViewRegistry.shared.views[viewId] else {
                result(
                    FlutterError(
                        code: "NO_VIEW",
                        message: "AdView is not exist",
                        details: nil
                    )
                )
                return
            }
            
            PubstarAdManagerWrapper.loadAndShowAd(
                adId: adId,
                view: adView,
                onLoaderError: onErrorCallback(callbackId: callbackId, message: "onAdLoader is failed."),
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onShowedError: onErrorCallback(callbackId: callbackId, message: "onShowed is failed."),
            )
        case "loadAndShowBannerAd":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let viewId = call.extractViewId(result: result) else { return }
            let tag = call.extractBannerSize(result: result)
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            guard let adView = PubstarAdViewRegistry.shared.views[viewId] else {
                result(
                    FlutterError(
                        code: "NO_VIEW",
                        message: "AdView is not exist",
                        details: nil
                    )
                )
                return
            }
            
            PubstarAdManagerWrapper.loadAndShowBannerAd(
                adId: adId,
                view: adView,
                tag: tag,
                onLoaderError: onErrorCallback(callbackId: callbackId, message: "onAdLoader is failed."),
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onShowedError: onErrorCallback(callbackId: callbackId, message: "onShowed is failed."),
            )
        case "loadAndShowNativeAd":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let viewId = call.extractViewId(result: result) else { return }
            let size = call.extractNativeSize(result: result)
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            guard let adView = PubstarAdViewRegistry.shared.views[viewId] else {
                result(
                    FlutterError(
                        code: "NO_VIEW",
                        message: "AdView is not exist",
                        details: nil
                    )
                )
                return
            }
            
            PubstarAdManagerWrapper.loadAndShowNativeAd(
                adId: adId,
                view: adView,
                size: size,
                onLoaderError: onErrorCallback(callbackId: callbackId, message: "onAdLoader is failed."),
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onShowedError: onErrorCallback(callbackId: callbackId, message: "onShowed is failed."),
            )
        case "loadAndShowVideoAd":
            guard let adId = call.extractAdId(result: result) else { return }
            guard let viewId = call.extractViewId(result: result) else { return }
            guard let media = call.extractMedia(result: result) else { return }
            guard let callbackId = call.extractCallbackIdId(result: result) else { return }
            
            guard let adView = PubstarAdViewRegistry.shared.views[viewId] else {
                result(
                    FlutterError(
                        code: "NO_VIEW",
                        message: "AdView is not exist",
                        details: nil
                    )
                )
                return
            }
            
            guard let url = URL(string: media) else {
                return
            }
            
            PubstarAdManagerWrapper.loadAndShowVideoAd(
                adId: adId,
                view: adView,
                media: AVPlayer(url: url),
                onLoaderError: onErrorCallback(callbackId: callbackId, message: "onLoaded is failed."),
                onLoaded: onAdLoadedCallback(callbackId: callbackId),
                onHide: onAdHideCallback(callbackId: callbackId),
                onShowed: onAdShowedCallback(callbackId: callbackId),
                onShowedError: onErrorCallback(callbackId: callbackId, message: "onShowed is failed."),
            )

        default:
          result(FlutterMethodNotImplemented)
        }
    }
}
