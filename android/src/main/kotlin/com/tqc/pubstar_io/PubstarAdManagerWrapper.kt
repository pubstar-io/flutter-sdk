package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.content.Context
import io.pubstar.mobile.ads.interfaces.AdLoaderListener
import io.pubstar.mobile.ads.interfaces.InitAdListener
import io.pubstar.mobile.ads.interfaces.PubStarAdController
import io.pubstar.mobile.ads.model.ErrorCode
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
}