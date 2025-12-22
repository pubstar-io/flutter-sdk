//
//  PubstarAdManagerWrapper.swift
//  pubstar_io
//
//  Created by Mobile  on 10/6/25.
//

import Pubstar
import AVFoundation

@available(iOS 13.0, *)
public final class PubstarAdManagerWrapper {
    private static let _pubStarAdManager = PubStarAdManager.getInstance()
    private static let _pubStarAdController = PubStarAdManager.getAdController()
    private static var _context: UIViewController? = PubStarUtils.getHostingViewController()
    
    private init() {
        
    }
    
    public static func initPubstar(
        onDone: @escaping () -> Void,
        onError: @escaping (ErrorCode) -> Void
    ) {
        PubStarAdManager.getInstance()
            .setInitAdListener(InitAdListenerHandler(
                onDone: {
                    onDone()
                },
                onError: { errorCode in
                    onError(errorCode)
                }
            ))
            .initAd()
    }
    
    public static func loadAd(
        adId: String,
        onLoaded: @escaping () -> Void,
        onError: @escaping (ErrorCode) -> Void
    ) {
        if _context == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            onLoaded()
        } onError: { errorCode in
            onError(errorCode)
        }
        
        _pubStarAdController.load(
            context: _context!,
            key: adId,
            adLoaderListener: adNetLoaderListener
        )
    }
    
    public static func showAd(
        adId: String,
        view: UIView? = nil,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onError: @escaping (ErrorCode) -> Void
    ) {
        if _context == nil {
            return
        }
        
        let adShowedListener: AdShowedListener = AdShowedHandler {
            onShowed()
        } onHide: { state in
            onHide(state)
        } onError: { errorCode in
            onError(errorCode)
        }
        
        _pubStarAdController.show(
            context: _context!,
            key: adId,
            view: view,
            adShowedListener: adShowedListener
        )
    }
    
    public static func loadAndShowAd(
        adId: String,
        view: UIView? = nil,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void
    ) {
        if _context == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            onLoaded()
        } onError: { code in
            onLoaderError(code)
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            onShowed()
        } onHide: { state in
            onHide(state)
        } onError: { errorCode in
            onShowedError(errorCode)
        }
        
        _pubStarAdController
            .loadAndShow(
                context: _context!,
                key: adId,
                view: view,
                adLoaderListener: adNetLoaderListener,
                adShowedListener: adNetShowListener
            )
    }
    
    public static func loadAndShowNativeAd(
        adId: String,
        view: UIView? = nil,
        size: NativeAdRequest.TypeSize,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void
    ) {
        if _context == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            onLoaded()
        } onError: { code in
            onLoaderError(code)
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            onShowed()
        } onHide: { state in
            onHide(state)
        } onError: { errorCode in
            onShowedError(errorCode)
        }
        
        let request = NativeAdRequest.Builder(context: _context!)
            .withView(view)
            .sizeType(size)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)
            .build()
        
        _pubStarAdController
            .loadAndShow(
                key: adId,
                adRequest: request
            )
    }
    
    public static func loadAndShowBannerAd(
        adId: String,
        view: UIView? = nil,
        tag: BannerAdRequest.AdTag,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void
    ) {
        if _context == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            onLoaded()
        } onError: { code in
            onLoaderError(code)
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            onShowed()
        } onHide: { state in
            onHide(state)
        } onError: { errorCode in
            onShowedError(errorCode)
        }
        
        let request = BannerAdRequest.Builder(context: _context!)
            .withView(view)
            .tag(tag)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)
            .build()
        
        _pubStarAdController
            .loadAndShow(
                key: adId,
                adRequest: request
            )
    }
    
    public static func loadAndShowVideoAd(
        adId: String,
        view: UIView? = nil,
        media: AVPlayer,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void

    ){
        if _context == nil {
            return
        }
        
        let adNetLoaderListener: AdLoaderListener = AdLoaderHandler {
            onLoaded()
        } onError: { code in
            onLoaderError(code)
        }
        
        let adNetShowListener: AdShowedListener = AdShowedHandler {
            onShowed()
        } onHide: { state in
            onHide(state)
        } onError: { errorCode in
            onShowedError(errorCode)
        }
        
        let request = IMARequest.Builder(context: _context!)
            .isAllowCache(true)
            .withView(view)
            .withMedia(media)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)
            .build()
        
        _pubStarAdController
            .loadAndShow(
                key: adId,
                adRequest: request
            )
    }
}
