//
//  PubstarAdManagerWrapper.swift
//  pubstar_io
//
//  Created by Mobile  on 10/6/25.
//

import AVFoundation
import Pubstar

class VideoPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}

@available(iOS 13.0, *)
public final class PubstarAdManagerWrapper {
    private static let _pubStarAdManager = PubStarAdManager.getInstance()
    private static let _pubStarAdController = PubStarAdManager.getAdController()
    private static var _context: UIViewController? =
        PubStarUtils.getHostingViewController()

    private init() {

    }

    public static func initPubstar(
        onDone: @escaping () -> Void,
        onError: @escaping (ErrorCode) -> Void
    ) {
        guard let context = _context else {
            onError(ErrorCode.NO_INIT)
            return
        }

        PubStarAdManager.gatherConsent(
            from: context,
            listener: ConsentGatheringCompleteHandler(onComplete: { error in
                PubStarAdManager.getInstance()
                    .setIsDebug(isDebug: true)
                    .setInitAdListener(
                        InitAdListenerHandler(
                            onDone: {
                                onDone()
                            },
                            onError: { errorCode in
                                onError(errorCode)
                            }
                        )
                    )
                    .initAd()
            })
        )
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
        onShowedError: @escaping (ErrorCode) -> Void,
        customConfig: NativeAdViewBinder? = nil
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

        var request: NativeAdRequest
        if customConfig != nil {
            request = NativeAdRequest.Builder(context: _context!)
                .withView(view)
                .withNativeAdViewBinderCustom(customConfig!)
                .sizeType(.Custom)
                .adLoaderListener(adNetLoaderListener)
                .adShowedListener(adNetShowListener)
                .build()
        } else {
            request = NativeAdRequest.Builder(context: _context!)
                .withView(view)
                .sizeType(size)
                .adLoaderListener(adNetLoaderListener)
                .adShowedListener(adNetShowListener)
                .build()
        }

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
        view: UIView,
        media: String,
        type: IMARequest.IMAType,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void

    ) {
        print("[TEST] loadAndShowVideoAd adId: \(adId)")
        print("[TEST] loadAndShowVideoAd view: \(view)")
        print("[TEST] loadAndShowVideoAd type: \(type)")
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
            .withView(view)
            .withSize(IMARequest.IMASize.medium)
            .withType(type)
            .adLoaderListener(adNetLoaderListener)
            .adShowedListener(adNetShowListener)

        if type == .inStream {
            let player = self.createPlayerVideo(url: media)
            let _ = request.withMedia(player)
        }

        _pubStarAdController.loadAndShow(key: adId, adRequest: request.build())
    }
    
    private static func createPlayerVideo(url: String) -> AVPlayer? {
        guard let url = URL(string: url) else {
            return nil
        }

        let player = AVPlayer(url: url)
        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()

        return player
    }
}
