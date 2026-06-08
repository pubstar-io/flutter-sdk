package com.tqc.pubstar_io

import android.content.Context
import android.graphics.Color
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
    // Container gốc chứa cả video và quảng cáo
    private val rootContainer = RelativeLayout(context)

    // View để hiển thị video (Ví dụ: SurfaceView, PlayerView của ExoPlayer, hoặc VideoView)
    private val videoSurfaceView = SurfaceView(context)

    // View dành riêng cho IMA/Pubstar render quảng cáo
    private val adContainer = FrameLayout(context)



    init {
        // 1. Setup layout cho Video
        val videoParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        videoParams.addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE)
        videoSurfaceView.layoutParams = videoParams
//        videoSurfaceView.setBackgroundColor(Color.RED)
        rootContainer.addView(videoSurfaceView)

        // 2. Setup layout cho AdContainer (nằm đè lên trên Video)
        val adParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        adParams.addRule(RelativeLayout.ALIGN_TOP, videoSurfaceView.id)
        adParams.addRule(RelativeLayout.ALIGN_BOTTOM, videoSurfaceView.id)
        adContainer.layoutParams = adParams
        rootContainer.addView(adContainer)
    }

    override fun getView(): View {
        return rootContainer
    }

    // Hàm public hoặc getter để wrapper lấy adContainer pass vào withView()
    fun getAdContainer(): FrameLayout {
        return adContainer
    }

    override fun dispose() {
        PubstarAdViewRegistry.views.remove(id)
    }
}