package com.tqc.pubstar_io

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.pubstar.mobile.core.base.BannerAdRequest
import io.pubstar.mobile.core.base.NativeAdRequest
import io.pubstar.mobile.core.models.ErrorCode
import io.pubstar.mobile.core.models.RewardModel

enum class PubstarAdEvent {
    LOADED,
    SHOWED,
    HIDE,
    ERROR,
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
        cbId: String? = null,
        payload: Map<String, Any?> = emptyMap(),
    ) {
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
            callbackId: String,
            message: String = "Pubstar is error"
        ): (ErrorCode) -> Unit {
            return { errorCode ->
                emitCallback(
                    event = PubstarAdEvent.ERROR,
                    cbId = callbackId,
                    mapOf(
                        "code" to errorCode.code,
                        "name" to errorCode.name,
                        "message" to message
                    )
                )
            }
        }

        fun onAdHideCallback(callbackId: String): (reward: RewardModel?) -> Unit {
            return { reward ->
                var payload: Map<String, Any?> = emptyMap()
                if (reward != null) {
                    payload = mapOf(
                        "type" to reward.type,
                        "amount" to reward.amount
                    )
                }

                emitCallback(
                    event = PubstarAdEvent.HIDE,
                    cbId = callbackId,
                    payload = payload,
                )
            }
        }

        fun onAdShowedCallback(callbackId: String): () -> Unit {
            return {
                emitCallback(
                    event = PubstarAdEvent.SHOWED,
                    cbId = callbackId
                )
            }
        }

        fun onAdLoadedCallback(callbackId: String): () -> Unit {
            return {
                emitCallback(
                    event = PubstarAdEvent.LOADED,
                    cbId = callbackId
                )
            }
        }

        fun onInitDoneCallback(): () -> Unit {
            return {
                result.success(true)
            }
        }

        fun onInitErrorCallback(): (ErrorCode) -> Unit {
            return { errorCode ->
                result.error(
                    errorCode.code.toString(),
                    "Pubstar init error",
                    mapOf(
                        "code" to errorCode.code,
                        "name" to errorCode.name,
                        "message" to "Pubstar init failed"
                    )
                )
            }
        }

        when (call.method) {
            "init" -> {
                pubstarAdManagerWrapper.init(
                    onDone = onInitDoneCallback(),
                    onError = onInitErrorCallback()
                )
            }

            "loadAd" -> {
                val adId = Validate.adId(call.argument<Any>("adId"), result) ?: return
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAd(
                    adId,
                    onLoaded = onAdLoadedCallback(callbackId),
                    onError = onErrorCallback(
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
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onError = onErrorCallback(
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
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onError = onErrorCallback(
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
                    onAdLoaded = onAdLoadedCallback(callbackId),
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onAdShowedError = onErrorCallback(
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
                    onAdLoaded = onAdLoadedCallback(callbackId),
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onAdShowedError = onErrorCallback(
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
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowBannerAd(
                    adId,
                    adView,
                    size,
                    onAdLoaderError = onErrorCallback(
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(callbackId),
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onAdShowedError = onErrorCallback(
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
                val callbackId = Validate.callbackId(call.argument<Any>("callbackId"), result) ?: return

                pubstarAdManagerWrapper.loadAndShowNativeAd(
                    adId,
                    adView,
                    size,
                    onAdLoaderError = onErrorCallback(
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(callbackId),
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onAdShowedError = onErrorCallback(
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
                        callbackId = callbackId,
                        message = "onAdLoader is failed."
                    ),
                    onAdLoaded = onAdLoadedCallback(callbackId),
                    onAdHide = onAdHideCallback(callbackId),
                    onAdShowed = onAdShowedCallback(callbackId),
                    onAdShowedError = onErrorCallback(
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

