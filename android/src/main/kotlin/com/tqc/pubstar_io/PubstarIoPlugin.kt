package com.tqc.pubstar_io

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
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
    ERROR,
    INIT
}

class PubstarIoPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context
    private lateinit var applicationContext: Context

    private val methodChanelName = "pubstar_io"
    private val methodChannelCallbackName = "pubstar_io#callback"
    private val nativeViewId = "pubstar_ad_view"

    private val mainHandler by lazy { Handler(Looper.getMainLooper()) }

    private fun emitCallback(
        event: PubstarAdEvent,
        adId: String? = null,
        cbId: String? = null,
        payload: Map<String, Any?> = emptyMap(),
    ) {
        Log.d("FLUTTER - Native", "emit call with event: $event - adId: $adId - callbackId: $cbId")
        val args = HashMap<String, Any?>()
        args["event"] = event.name
        if (!cbId.isNullOrEmpty()) args["cbId"] = cbId
        args.putAll(payload)

        mainHandler.post {
            channel.invokeMethod(methodChannelCallbackName, args)
        }
    }

    private fun registerMethodChanel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, methodChanelName)
        channel.setMethodCallHandler(this)
    }

    private fun registerNativeView(flutterPluginBinding: FlutterPluginBinding) {
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(nativeViewId, NativeViewFactory())
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        applicationContext = flutterPluginBinding.applicationContext

        registerMethodChanel(flutterPluginBinding.binaryMessenger)

        registerNativeView(flutterPluginBinding)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val pubstarAdManagerWrapper = PubstarAdManagerWrapper.getInstance(mContext)

        fun onErrorCallback(
            adId: String,
            callbackId: String,
            message: String = "Pubstar is error"
        ): (ErrorCode) -> Unit {
            return { errorCode ->
                emitCallback(
                    event = PubstarAdEvent.ERROR,
                    adId = adId,
                    cbId = callbackId,
                    mapOf(
                        "errorCode" to errorCode.name,
                        "errorRawValue" to errorCode.code.toString()
                    )
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

        fun onAdHideCallback(adId: String, callbackId: String): () -> Unit {
            return {
                emitCallback(
                    event = PubstarAdEvent.HIDE,
                    adId = adId,
                    cbId = callbackId
                )
            }
        }

        fun onAdShowedCallback(adId: String, callbackId: String): () -> Unit {
            return {
                emitCallback(
                    event = PubstarAdEvent.SHOWED,
                    adId = adId,
                    cbId = callbackId
                )
            }
        }

        fun onAdLoadedCallback(adId: String, callbackId: String): () -> Unit {
            return {
                emitCallback(
                    event = PubstarAdEvent.LOADED,
                    adId = adId,
                    cbId = callbackId
                )
            }
        }

        fun onInitCallback(callbackId: String): () -> Unit {
            return {
                emitCallback(event = PubstarAdEvent.INIT, cbId = callbackId)
                result.success(true)
            }
        }

        when (call.method) {
            "init" -> {
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.init(
                    onDone = onInitCallback(callbackId),
                    onError = onErrorCallback(
                        adId = "",
                        callbackId = callbackId,
                        message = "Pubstar init failed"
                    )
                )
            }

            "loadAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAd(
                    adId,
                    onLoaded = {
                        onAdLoadedCallback(
                            adId = adId,
                            callbackId = callbackId
                        )
                        result.success(true)
                    },
                    onError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "loadAd is failed."
                    )
                )
            }

            "showAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.showAd(
                    adId,
                    null,
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "showAd is failed."
                    )
                )
            }

            "showAdWithViewId" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.showAd(
                    adId,
                    adView,
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onShowed is failed."
                    )
                )
            }

            "loadAndShowAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowAd(
                    adId,
                    null,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId, callbackId),
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onAdShowedError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onShowed is failed."
                    )
                )
            }

            "loadAndShowAdWithViewId" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowAd(
                    adId,
                    adView,
                    onAdLoaderError = onErrorCallback(adId,"onAdLoader is failed."),
                    onAdLoaded = onAdLoadedCallback(adId, callbackId),
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onAdShowedError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onShowed is failed."
                    )
                )
            }

            "loadAndShowBannerAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val tag = Validate.tag(call.argument<String>("tag"), result) ?: return
                val size = extractBannerSize(tag)
                val isAllowLoadNext = Validate.isAllowLoadNext(call.argument<Boolean>("isAllowLoadNext"))
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowBannerAd(
                    adId,
                    adView,
                    size,
                    isAllowLoadNext,
                    onAdLoaderError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(adId, callbackId),
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onAdShowedError = onErrorCallback(
                        adId = adId,
                        callbackId= callbackId,
                        message = "onShowed is failed."
                    )
                )
            }

            "loadAndShowNativeAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val typeSize = Validate.typeSize(call.argument<String>("typeSize"), result) ?: return
                val size = extractNativeSize(typeSize)
                val isAllowLoadNext = Validate.isAllowLoadNext(call.argument<Boolean>("isAllowLoadNext"))
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowNativeAd(
                    adId,
                    adView,
                    size,
                    isAllowLoadNext,
                    onAdLoaderError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(adId, callbackId),
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onAdShowedError = onErrorCallback(
                        adId = adId,
                        callbackId= callbackId,
                        message = "onShowed is failed."
                    )
                )
            }

            "loadAndShowVideoAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val adView = Validate.adView(call.argument<Int>("viewId"), result) ?: return
                val media = Validate.media(call.argument<String>("media"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

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
                    onAdLoaderError = onErrorCallback(
                        adId = adId,
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(adId, callbackId),
                    onAdHide = onAdHideCallback(adId, callbackId),
                    onAdShowed = onAdShowedCallback(adId, callbackId),
                    onAdShowedError = onErrorCallback(
                        adId = adId,
                        callbackId= callbackId,
                        message = "onShowed is failed."
                    )
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

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mContext = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mContext = applicationContext
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mContext = binding.activity
    }

    override fun onDetachedFromActivity() {
        mContext = applicationContext
    }
}

