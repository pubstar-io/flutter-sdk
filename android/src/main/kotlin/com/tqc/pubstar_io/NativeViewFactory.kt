package com.tqc.pubstar_io

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val adView = NativeView(context, viewId)
        PubstarAdViewRegistry.views[viewId] = adView.getAdContainer()

//        PubstarAdViewRegistry.views[viewId] = adView.view
        return adView
    }
}