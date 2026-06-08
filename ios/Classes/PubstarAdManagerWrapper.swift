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
        PubStarAdManager.getInstance()
            .setIsDebug(isDebug: true)
            .setInitAdListener(
                InitAdListenerHandler(
                    onDone: {
                        onDone()
                    },
                    onError: { errorCode in
                        print("[TEST] initAd error: \(errorCode)")
                        onError(errorCode)
                    }
                )
            )
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
        view: UIView,
        media: AVPlayer,
        onLoaderError: @escaping (ErrorCode) -> Void,
        onLoaded: @escaping () -> Void,
        onHide: @escaping (RewardModel?) -> Void,
        onShowed: @escaping () -> Void,
        onShowedError: @escaping (ErrorCode) -> Void

    ) {
        print("[TEST] loadAndShowVideoAd adId: \(adId)")
        print("[TEST] loadAndShowVideoAd view: \(view)")
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

        //        view.backgroundColor = .red
        //        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: media)
        //        playerLayer.frame = view.bounds
        //        playerLayer.videoGravity = .resizeAspect
        //        view.layer.sublayers?.forEach {
        //            $0.removeFromSuperlayer()
        //        }
        //        view.layer.addSublayer(playerLayer)
        //        media.play()

        //        DispatchQueue.main.async {
        //            view.backgroundColor = .red
        //
        //            // Dọn dẹp các subview cũ (nếu tái sử dụng view)
        //            view.subviews.forEach { $0.removeFromSuperview() }
        //
        //            let videoView = VideoPlayerView(frame: view.bounds)
        //            videoView.playerLayer.player = media
        //            videoView.playerLayer.videoGravity = .resizeAspect
        //
        //            // Thiết lập auto-resize để videoView tự bám theo viền của view cha (Flutter Platform View)
        //            videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
        //            view.addSubview(videoView)
        //            media.play()
        //
        //            let request = IMARequest.Builder(context: _context!)
        //                .withView(view)
        //                .withType(.inStream)
        //                .withMedia(media)
        //                .adLoaderListener(adNetLoaderListener)
        //                .adShowedListener(adNetShowListener)
        //                .build()
        //
        //            _pubStarAdController
        //                .loadAndShow(
        //                    key: adId,
        //                    adRequest: request
        //                )
        //        }

        //        =========== TEST ============
        DispatchQueue.main.async {
            view.backgroundColor = .black  // Chuẩn hoá màu nền video
            view.subviews.forEach { $0.removeFromSuperview() }

            let videoView = VideoPlayerView(frame: view.bounds)
            videoView.playerLayer.player = media
            videoView.playerLayer.videoGravity = .resizeAspect
            videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(videoView)
            media.play()

            let request = IMARequest.Builder(context: _context!)
                .withView(view)  // IMA sẽ render UI quảng cáo đè lên view này
                .withType(.inStream)
                .withMedia(media)
                .adLoaderListener(adNetLoaderListener)
                .adShowedListener(adNetShowListener)
                .build()

            _pubStarAdController.loadAndShow(key: adId, adRequest: request)
        }
    }

}
