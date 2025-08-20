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
    
    private static func registerNativeView(registrar: FlutterPluginRegistrar) {
        registrar.register(NativeViewFactory(), withId: nativeViewId)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        registerMethodChanel(registrar: registrar)

        registerNativeView(registrar: registrar)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let channel = self.channel else {
            result(FlutterError(code: "\(ErrorCode.NO_INIT.rawValue)", message: "Channel not initialized", details: nil))
           return
       }
        
        func onErrorCallback(callbackId: String, message: String = "Pubstar is error") -> (ErrorCode) -> Void {
            return { errorCode in
                channel.invokeMethod(
                    self.methodChannelCallback,
                    arguments: [
                        "cbId": callbackId,
                        "event": "\(PubstarAdEvent.ERROR)",
                        "code": errorCode.rawValue,
                        "name": "\(errorCode)",
                        "message": message
                    ]
                )
            }
        }
        
        func onAdHideCallback(callbackId: String) -> (RewardModel?) -> Void {
            return { reward in
                var arguments: [String: Any] = [
                    "cbId": callbackId,
                    "event": "\(PubstarAdEvent.HIDE)"
                ]

                if let reward = reward {
                    arguments["type"] = reward.type
                    arguments["amount"] = reward.amount
                }

                channel.invokeMethod(self.methodChannelCallback, arguments: arguments)
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
