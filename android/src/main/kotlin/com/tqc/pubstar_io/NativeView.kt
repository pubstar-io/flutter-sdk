package com.tqc.pubstar_io

import android.content.Context
import android.view.Gravity
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.RelativeLayout
import io.flutter.plugin.platform.PlatformView

internal class NativeViews(context: Context, id: Int) :
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


internal class NativeView(context: Context, private val id: Int) : PlatformView {
    private val rootContainer = RelativeLayout(context)

    private val videoSurfaceView = SurfaceView(context)

    private val adContainer = FrameLayout(context)

    val view: ViewGroup get() = rootContainer

    init {
        // 1. Setup layout cho Video
        val videoParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        videoParams.addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE)
        videoSurfaceView.layoutParams = videoParams
        rootContainer.addView(videoSurfaceView)

        // 2. Setup layout cho AdContainer (nằm đè lên trên Video)
        val adParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        adParams.addRule(RelativeLayout.ALIGN_TOP, videoSurfaceView.id)
        adParams.addRule(RelativeLayout.ALIGN_BOTTOM, videoSurfaceView.id)
        adContainer.layoutParams = videoParams
        rootContainer.addView(adContainer)
    }

    override fun getView(): View {
        return rootContainer
    }

    override fun dispose() {
        PubstarAdViewRegistry.views.remove(id)
    }
}