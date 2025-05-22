package com.tqc.pubstar_io

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import io.pubstar.mobile.ads.interfaces.InitAdListener
import io.pubstar.mobile.ads.model.ErrorCode
import io.pubstar.mobile.ads.pub.PubStarAdManager
import io.flutter.plugin.common.MethodChannel

class PubstarAdManagerWrapper private constructor(private val mContext: Context) {
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

    fun init(result: MethodChannel.Result) {
        PubStarAdManager.getInstance()
            .setInitAdListener(object : InitAdListener {
                override fun onDone() {
                    result.success(true)
                }

                override fun onError(code: ErrorCode) {
                    result.error("PubstarAdManagerWrapper", code.name, null)
                }
            })
            .init(mContext)
    }
}