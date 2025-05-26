package com.tqc.pubstar_io

import android.content.Context
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView

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