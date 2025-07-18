package com.tqc.pubstar_io

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.pubstar.mobile.ads.base.BannerAdRequest
import io.pubstar.mobile.ads.base.NativeAdRequest
import io.pubstar.mobile.ads.model.ErrorCode


enum class PubstarAdEvent {
    LOADED,
    SHOWED,
    HIDE,
    ERROR
}

class PubstarIoPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context
    private lateinit var eventChannel: EventChannel

    private val methodChanelName = "pubstar_io"
    private val eventChanelName = "pubstar_io_event"
    private val nativeViewId = "pubstar_ad_view"

    private fun registerMethodChanel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, methodChanelName)
        channel.setMethodCallHandler(this)
    }

    private fun registerEventChanel(messenger: BinaryMessenger) {
        eventChannel = EventChannel(messenger, eventChanelName)
        eventChannel.setStreamHandler(PubstarEventStreamHandler.shared)
    }

    private fun registerNativeView(flutterPluginBinding: FlutterPluginBinding) {
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(nativeViewId, NativeViewFactory())

    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext

        registerMethodChanel(flutterPluginBinding.binaryMessenger)

        registerEventChanel(flutterPluginBinding.binaryMessenger)

        registerNativeView(flutterPluginBinding)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val pubstarAdManagerWrapper = PubstarAdManagerWrapper.getInstance(mContext)

        fun onErrorCallback(adId: String, message: String = "Pubstar is error"): (ErrorCode) -> Unit {
            return { errorCode ->
                PubstarEventStreamHandler.shared
                    .sendAdEvent(
                        PubstarAdEvent.ERROR,
                        adId,
                        mapOf("error" to errorCode.name)
                    )

                result.error(
                    errorCode.name,
                    message,
                    mapOf(
                        "errorCode" to errorCode.name,
                        "errorRawValue" to errorCode.code.toString()
                    )
                )
            }
        }

        fun onAdHideCallback(adId: String): () -> Unit {
            return {
                PubstarEventStreamHandler.shared
                    .sendAdEvent(
                        PubstarAdEvent.HIDE,
                        adId
                    )
            }
        }

        fun onAdShowedCallback(adId: String): () -> Unit {
            return {
                PubstarEventStreamHandler.shared
                    .sendAdEvent(
                        PubstarAdEvent.SHOWED,
                        adId
                    )
            }
        }

        fun onAdLoadedCallback(adId: String): () -> Unit {
            return {
                PubstarEventStreamHandler.shared
                    .sendAdEvent(
                        PubstarAdEvent.LOADED,
                        adId,
                    )
            }
        }

        when (call.method) {
            "init" -> {
                pubstarAdManagerWrapper.init(
                    onDone = {
                        result.success(true)
                    },
                    onError = onErrorCallback("","Pubstar initialization failed.")
                )
            }

            "loadAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return

                pubstarAdManagerWrapper.loadAd(
                    adId,
                    onLoaded = {
                        result.success(true)
                    },
                    onError = onErrorCallback(adId,"loadAd is failed.")
                )
            }

            "showAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return

                pubstarAdManagerWrapper.showAd(
                    adId,
                    null,
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onError = onErrorCallback(adId,"showAd is failed.")
                )
            }

            "showAdWithViewId" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return

                pubstarAdManagerWrapper.showAd(
                    adId,
                    adView,
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onError = onErrorCallback(adId,"onShowed is failed.")
                )
            }

            "loadAndShowAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowAd(
                    adId,
                    null,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId),
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onAdShowedError = onErrorCallback(adId, "onShowed is failed.")
                )
            }

            "loadAndShowAdWithViewId" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowAd(
                    adId,
                    adView,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId),
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onAdShowedError = onErrorCallback(adId, "onShowed is failed.")
                )
            }

            "loadAndShowBannerAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val tag = Validate.tag(call.argument<String>("tag"), result) ?: return
                val size = extractBannerSize(tag)
                val isAllowLoadNext = Validate.isAllowLoadNext(call.argument<Boolean>("isAllowLoadNext"))

                pubstarAdManagerWrapper.loadAndShowBannerAd(
                    adId,
                    adView,
                    size,
                    isAllowLoadNext,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId),
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onAdShowedError = onErrorCallback(adId, "onShowed is failed.")
                )
            }

            "loadAndShowNativeAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val typeSize = Validate.typeSize(call.argument<String>("typeSize"), result) ?: return
                val size = extractNativeSize(typeSize)
                val isAllowLoadNext = Validate.isAllowLoadNext(call.argument<Boolean>("isAllowLoadNext"))

                pubstarAdManagerWrapper.loadAndShowNativeAd(
                    adId,
                    adView,
                    size,
                    isAllowLoadNext,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId),
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onAdShowedError = onErrorCallback(adId, "onShowed is failed.")
                )
            }

            "loadAndShowVideoAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val media = Validate.media(call.argument<String>("media"), result) ?: return

                val mediaPlayer = MediaPlayer()
                mediaPlayer.setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MOVIE)
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .build()
                )
                mediaPlayer.setDataSource(media)

                pubstarAdManagerWrapper.loadAndShowVideoAd(
                    adId = adId,
                    view = adView,
                    media = mediaPlayer,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId),
                    onAdHide = onAdHideCallback(adId),
                    onAdShowed = onAdShowedCallback(adId),
                    onAdShowedError = onErrorCallback(adId, "onShowed is failed.")
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun extractNativeSize(size: String): NativeAdRequest.Type {
        return when (size) {
            "small" -> {
                NativeAdRequest.Type.Small
            }

            "medium" -> {
                NativeAdRequest.Type.Medium
            }

            "big" -> {
                NativeAdRequest.Type.Big
            }

            else -> {
                NativeAdRequest.Type.Small
            }
        }
    }

    private fun extractBannerSize(tag: String): BannerAdRequest.AdTag {
        return when (tag) {
            "small" -> {
                BannerAdRequest.AdTag.Small
            }

            "medium" -> {
                BannerAdRequest.AdTag.Medium
            }

            "big" -> {
                BannerAdRequest.AdTag.Big
            }

            "collapsible" -> {
                BannerAdRequest.AdTag.Collapsible
            }

            else -> {
                BannerAdRequest.AdTag.Small
            }
        }
    }
}

