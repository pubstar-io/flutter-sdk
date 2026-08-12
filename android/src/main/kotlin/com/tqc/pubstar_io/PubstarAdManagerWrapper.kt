package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.media.MediaPlayer
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.VideoView
import com.google.android.ump.FormError
import io.pubstar.mobile.core.base.BannerAdRequest
import io.pubstar.mobile.core.base.IMARequest
import io.pubstar.mobile.core.base.NativeAdRequest
import io.pubstar.mobile.core.base.NativeAdViewBinder
import io.pubstar.mobile.core.interfaces.AdLoaderListener
import io.pubstar.mobile.core.interfaces.AdShowedListener
import io.pubstar.mobile.core.interfaces.InitAdListener
import io.pubstar.mobile.core.interfaces.PubStarAdController
import io.pubstar.mobile.core.models.ErrorCode
import io.pubstar.mobile.core.models.RewardModel
import io.pubstar.mobile.core.api.PubStarAdManager
import io.pubstar.mobile.core.utils.GoogleMobileAdsConsentManager

data class NativeCustomConfig(
    val layoutName: String,
    val advertiserTextViewId: String? = null,
    val iconImageViewId: String? = null,
    val titleTextViewId: String? = null,
    val mediaContentViewGroupId: String? = null,
    val bodyTextViewId: String? = null,
    val callToActionButtonId: String? = null,
    val loadingViewId: String? = null,
    val ctaColorHex: String? = null,
) {
    companion object {
        fun fromMap(raw: Map<*, *>?): NativeCustomConfig? {
            if (raw == null) return null
            val layoutName = raw["layoutName"] as? String ?: return null
            if (layoutName.trim().isEmpty()) return null

            return NativeCustomConfig(
                layoutName = layoutName,
                advertiserTextViewId = raw["advertiserTextViewId"] as? String,
                iconImageViewId = raw["iconImageViewId"] as? String,
                titleTextViewId = raw["titleTextViewId"] as? String,
                mediaContentViewGroupId = raw["mediaContentViewGroupId"] as? String,
                bodyTextViewId = raw["bodyTextViewId"] as? String,
                callToActionButtonId = raw["callToActionButtonId"] as? String,
                loadingViewId = raw["loadingViewId"] as? String,
                ctaColorHex = raw["ctaColorHex"] as? String,
            )
        }
    }
}

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
        customConfig: NativeCustomConfig? = null,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onError: (ErrorCode) -> Unit,
    ) {
        val binder = buildNativeAdViewBinder(customConfig)
        if (binder != null) {
            val requestBuilder = NativeAdRequest.Builder(mContext)
                .withView(view)
                .withNativeAdViewBinderCustom(binder)
                .sizeType(NativeAdRequest.Type.Custom)
                .adShowedListener(object : AdShowedListener {
                    override fun onAdHide(any: RewardModel?) {
                        onAdHide(any)
                    }

                    override fun onAdShowed() {
                        onAdShowed()
                    }

                    override fun onError(code: ErrorCode) {
                        onError(code)
                    }
                })

            val customColor = parseColorSafe(customConfig?.ctaColorHex)
            if (customColor != null) {
                requestBuilder.colorCTA(customColor)
            }

            val request = requestBuilder.build()
            pubStarAdController.show(adId, request)
            return
        }

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
        customConfig: NativeCustomConfig? = null,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: (RewardModel?) -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        val requestBuilder = NativeAdRequest.Builder(mContext)
            .withView(view)
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

        val binder = buildNativeAdViewBinder(customConfig)
        if (binder != null) {
            requestBuilder.withNativeAdViewBinderCustom(binder)
            requestBuilder.sizeType(NativeAdRequest.Type.Custom)

            val customColor = parseColorSafe(customConfig?.ctaColorHex)
            if (customColor != null) {
                requestBuilder.colorCTA(customColor)
            }
        } else {
            requestBuilder.sizeType(size)
        }

        val request = requestBuilder.build()


        pubStarAdController.loadAndShow(
            adId,
            request
        )
    }

    private fun buildNativeAdViewBinder(config: NativeCustomConfig?): NativeAdViewBinder? {
        if (config == null) return null
        val inflater = LayoutInflater.from(mContext)
        val layoutId = resolveResId(config.layoutName, "layout")
        if (layoutId == 0) return null

        val loadingView = resolveOptionalView(inflater, config.loadingViewId)
        val builder = NativeAdViewBinder.Builder(layoutId)

        resolveResId(config.advertiserTextViewId, "id").takeIf { it != 0 }?.let {
            builder.setAdvertiserTextViewId(it)
        }
        resolveResId(config.iconImageViewId, "id").takeIf { it != 0 }?.let {
            builder.setIconImageViewId(it)
        }
        resolveResId(config.titleTextViewId, "id").takeIf { it != 0 }?.let {
            builder.setTitleTextViewId(it)
        }
        resolveResId(config.mediaContentViewGroupId, "id").takeIf { it != 0 }?.let {
            builder.setMediaContentViewGroupId(it)
        }
        resolveResId(config.bodyTextViewId, "id").takeIf { it != 0 }?.let {
            builder.setBodyTextViewId(it)
        }
        resolveResId(config.callToActionButtonId, "id").takeIf { it != 0 }?.let {
            builder.setCallToActionButtonId(it)
        }
        if (loadingView != null) {
            builder.setLoadingView(loadingView)
        }

        return builder.build()
    }

    private fun resolveOptionalView(inflater: LayoutInflater, viewName: String?): View? {
        if (viewName.isNullOrBlank()) return null
        val id = resolveResId(viewName, "layout")
        if (id == 0) return null
        val rootView = inflater.inflate(id, null, false)
        return rootView
    }

    private fun resolveResId(name: String?, type: String): Int {
        if (name.isNullOrBlank()) return 0
        return mContext.resources.getIdentifier(name, type, mContext.packageName)
    }

    private fun parseColorSafe(colorHex: String?): Int? {
        if (colorHex.isNullOrBlank()) return null
        return try {
            Color.parseColor(colorHex)
        } catch (_: IllegalArgumentException) {
            null
        }
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
