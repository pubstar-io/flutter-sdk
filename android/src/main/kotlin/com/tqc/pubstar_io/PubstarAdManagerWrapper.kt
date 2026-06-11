package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.media.MediaPlayer
import android.view.ViewGroup
import android.widget.VideoView
import com.google.android.ump.FormError
import io.pubstar.mobile.core.base.BannerAdRequest
import io.pubstar.mobile.core.base.IMARequest
import io.pubstar.mobile.core.base.NativeAdRequest
import io.pubstar.mobile.core.interfaces.AdLoaderListener
import io.pubstar.mobile.core.interfaces.AdShowedListener
import io.pubstar.mobile.core.interfaces.InitAdListener
import io.pubstar.mobile.core.interfaces.PubStarAdController
import io.pubstar.mobile.core.models.ErrorCode
import io.pubstar.mobile.core.models.RewardModel
import io.pubstar.mobile.core.api.PubStarAdManager
import io.pubstar.mobile.core.utils.GoogleMobileAdsConsentManager

class PubstarAdManagerWrapper private constructor(private val mContext: Context) {
    private val pubStarAdController: PubStarAdController by lazy {
        PubStarAdManager.getAdController()
    }

    companion object {
        @SuppressLint("StaticFieldLeak")
        @Volatile
        private var INSTANCE: PubstarAdManagerWrapper? = null

        fun getInstance(context: Context): PubstarAdManagerWrapper {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: PubstarAdManagerWrapper(context).also { INSTANCE = it }
            }
        }
    }

    fun init(
        onDone: () -> Unit,
        onError: (ErrorCode) -> Unit
    ) {
        if (mContext !is Activity) {
            onError(ErrorCode.INIT_ERROR)
            return
        }

        PubStarAdManager.gatherConsent(
            mContext,
            object : GoogleMobileAdsConsentManager.OnConsentGatheringCompleteListener {
                override fun consentGatheringComplete(error: FormError?) {
                    PubStarAdManager.getInstance()
                        .setInitAdListener(object : InitAdListener {
                            override fun onDone() {
                                onDone()
                            }

                            override fun onError(code: ErrorCode) {
                                onError(code)
                            }
                        })
                        .init(mContext)
                }
            }
        )
    }

    fun loadAd(
        adId: String,
        onLoaded: () -> Unit,
        onError: (ErrorCode) -> Unit
    ) {
        pubStarAdController.load(mContext, adId, object : AdLoaderListener {
            override fun onLoaded() {
                onLoaded()
            }

            override fun onError(code: ErrorCode) {
                onError(code)
            }
        })
    }

    fun showAd(
        adId: String,
        view: ViewGroup? = null,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onError: (ErrorCode) -> Unit,
    ) {
        pubStarAdController.show(
            mContext,
            adId,
            view,
            object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide(any)
                }

                override fun onAdShowed() {
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    onError(code)
                }

            }
        )
    }

    fun loadAndShowAd(
        adId: String,
        view: ViewGroup? = null,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        pubStarAdController.loadAndShow(
            mContext,
            adId,
            view,
            object : AdLoaderListener {
                override fun onError(code: ErrorCode) {
                    onAdLoaderError(code)
                }

                override fun onLoaded() {
                    onAdLoaded()
                }
            },
            object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide(any)
                }

                override fun onAdShowed() {
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    onAdShowedError(code)
                }
            }
        )
    }

    fun loadAndShowNativeAd(
        adId: String,
        view: ViewGroup? = null,
        size: NativeAdRequest.Type,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        val request = NativeAdRequest.Builder(mContext)
            .withView(view)
            .sizeType(size)
            .adLoaderListener(object : AdLoaderListener {
                override fun onError(code: ErrorCode) {
                    onAdLoaderError(code)
                }

                override fun onLoaded() {
                    onAdLoaded()
                }
            }
            )
            .adShowedListener(object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide(any)
                }

                override fun onAdShowed() {
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    onAdShowedError(code)
                }
            }
            )
            .build()


        pubStarAdController.loadAndShow(
            adId,
            request
        )
    }

    fun loadAndShowBannerAd(
        adId: String,
        view: ViewGroup? = null,
        size: BannerAdRequest.AdTag,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        val request = BannerAdRequest.Builder(mContext)
            .withView(view)
            .tag(size)
            .adLoaderListener(object : AdLoaderListener {
                override fun onError(code: ErrorCode) {
                    onAdLoaderError(code)
                }

                override fun onLoaded() {
                    onAdLoaded()
                }
            }
            )
            .adShowedListener(object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide(any)
                }

                override fun onAdShowed() {
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    onAdShowedError(code)
                }
            }
            )
            .build()

        pubStarAdController.loadAndShow(
            adId,
            request
        )
    }

    fun loadAndShowVideoAd(
        adId: String,
        view: ViewGroup,
        media: String,
        type: IMARequest.Type,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        val request = IMARequest.Builder(mContext)
            .isAllowCache(true)
            .withView(view)
            .withSize(IMARequest.Size.Medium)
            .withType(type)
            .adLoaderListener(object : AdLoaderListener {
                override fun onError(code: ErrorCode) {
                    onAdLoaderError(code)
                }

                override fun onLoaded() {
                    onAdLoaded()
                }
            }
            )
            .adShowedListener(object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide(any)
                }

                override fun onAdShowed() {
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    onAdShowedError(code)
                }
            })

        if (type == IMARequest.Type.IN_STREAM) {
            this.createVideoForInStreamAds(
                containerView = view,
                path = media,
                callback = { player ->
                    request.withMedia(player)
                }
            )
        }

        pubStarAdController.loadAndShow(
            adId,
            request.build()
        )
    }

    private fun createVideoForInStreamAds(
        containerView: ViewGroup,
        path: String,
        callback: (mediaPlayer: MediaPlayer) -> Unit
    ) {
        val videoPlayer = VideoView(mContext)

        val layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        videoPlayer.layoutParams = layoutParams
        containerView.addView(videoPlayer)

        videoPlayer.setVideoPath(path)
        videoPlayer.setOnPreparedListener { mp ->
            mp.isLooping = false
            videoPlayer.start()

            callback(mp)
        }
    }
}
