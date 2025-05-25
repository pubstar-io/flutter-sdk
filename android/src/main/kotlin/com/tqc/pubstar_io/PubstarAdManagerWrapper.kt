package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.content.Context
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.pubstar.mobile.ads.interfaces.AdLoaderListener
import io.pubstar.mobile.ads.interfaces.AdShowedListener
import io.pubstar.mobile.ads.interfaces.InitAdListener
import io.pubstar.mobile.ads.interfaces.PubStarAdController
import io.pubstar.mobile.ads.model.ErrorCode
import io.pubstar.mobile.ads.model.RewardModel
import io.pubstar.mobile.ads.pub.PubStarAdManager

object PubstarAdViewRegistry {
    val views = mutableMapOf<Int, ViewGroup>()
}

internal class NativeView(context: Context, id: Int) :
    PlatformView {
    private val frameLayout = FrameLayout(context)
    private val mId = id

    override fun getView(): ViewGroup {
        return frameLayout
    }

    override fun dispose() {
        PubstarAdViewRegistry.views.remove(mId)
    }

    init {
        val params = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        params.gravity = Gravity.CENTER
        frameLayout.layoutParams = params
    }
}

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val adView = NativeView(context, viewId)
        PubstarAdViewRegistry.views[viewId] = adView.view
        return adView
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
        onAdHide: () -> Unit,
        onAdShowed: () -> Unit,
        onError: (ErrorCode) -> Unit,
    ) {
        pubStarAdController.show(
            mContext,
            adId,
            view,
            object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    onAdHide()
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
}

object PubstarAdViewManager {
    private val viewMap = mutableMapOf<Int, ViewGroup>()
    fun registerView(viewId: Int, view: ViewGroup) { viewMap[viewId] = view }
    fun unregisterView(viewId: Int) { viewMap.remove(viewId) }
    fun getView(viewId: Int): ViewGroup? = viewMap[viewId]
}
