package com.tqc.pubstar_io

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.view.ViewGroup
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.pubstar.mobile.ads.base.BannerAdRequest
import io.pubstar.mobile.ads.base.NativeAdRequest

object Validate {
    fun adId(adId: Any?, result: Result): String? {
        if (adId !is String) {
            result.error(
                "INVALID_ARGUMENT",
                "Typeof adId is not a String",
                null
            )
            return null
        }

        if (adId.trim().isEmpty()) {
            result.error(
                "INVALID_ARGUMENT",
                "AdId is empty String",
                null
            )
            return null
        }

        return adId
    }

    fun adView(viewId: Any?, result: Result): ViewGroup? {
        val adView = PubstarAdViewRegistry.views[viewId]

        if (adView == null) {
            result.error(
                "NO_VIEW_TO_ATTACH",
                "AdView is not exist",
                null
            )
            return null
        }

        return adView
    }

    fun tag(tag: Any?, result: Result): String? {
        if (tag !is String) {
            result.error(
                "INVALID_ARGUMENT",
                "Typeof size is not a String",
                null
            )
            return null
        }

        return tag
    }

    fun typeSize(typeSize: Any?, result: Result): String? {
        if (typeSize !is String) {
            result.error(
                "INVALID_ARGUMENT",
                "Typeof size is not a String",
                null
            )
            return null
        }

        return typeSize
    }

    fun media(media: Any?, result: Result): String? {
        if (media !is String) {
            result.error(
                "INVALID_ARGUMENT",
                "Typeof Media is not a String",
                null
            )
            return null
        }

        if (media.trim().isEmpty()) {
            result.error(
                "INVALID_ARGUMENT",
                "Media is empty String",
                null
            )
            return null
        }

        return media
    }
}
