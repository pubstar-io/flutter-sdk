package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.ViewGroup
import io.pubstar.mobile.ads.interfaces.AdLoaderListener
import io.pubstar.mobile.ads.interfaces.AdShowedListener
import io.pubstar.mobile.ads.interfaces.InitAdListener
import io.pubstar.mobile.ads.interfaces.PubStarAdController
import io.pubstar.mobile.ads.model.ErrorCode
import io.pubstar.mobile.ads.model.RewardModel
import io.pubstar.mobile.ads.pub.PubStarAdManager

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

    fun loadAndShowAd(
        adId: String,
        view: ViewGroup? = null,
        onAdLoaderError: (ErrorCode) -> Unit,
        onAdLoaded: () -> Unit,
        onAdHide: () -> Unit,
        onAdShowed: () -> Unit,
        onAdShowedError: (ErrorCode) -> Unit,
    ) {
        pubStarAdController.loadAndShow(
            mContext,
            adId,
            view,
            object : AdLoaderListener {
                override fun onError(code: ErrorCode) {
                    Log.d("TAG", "onError: $code")
                    onAdLoaderError(code)
                }

                override fun onLoaded() {
                    Log.d("TAG", "onLoaded: ")
                    onAdLoaded()
                }
            },
            object : AdShowedListener {
                override fun onAdHide(any: RewardModel?) {
                    Log.d("TAG", "onAdHide: ")
                    onAdHide()
                }

                override fun onAdShowed() {
                    Log.d("TAG", "onAdShowed: ")
                    onAdShowed()
                }

                override fun onError(code: ErrorCode) {
                    Log.d("TAG", "onError: $code")
                    onAdShowedError(code)
                }
            }
        )
    }
}
