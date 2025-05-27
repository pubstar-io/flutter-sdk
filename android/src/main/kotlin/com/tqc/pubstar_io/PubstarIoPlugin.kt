package com.tqc.pubstar_io

import android.content.Context
import android.os.Build
import android.util.Log
import android.view.ViewGroup
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PubstarIoPlugin */
class PubstarIoPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mContext: Context
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pubstar_io")
    channel.setMethodCallHandler(this)

      eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "pubstar_io_event")
      eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
          override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
              eventSink = events
          }
          override fun onCancel(arguments: Any?) {
              eventSink = null
          }
      })


      flutterPluginBinding
        .platformViewRegistry
        .registerViewFactory("pubstar_ad_view", NativeViewFactory())
  }

    private fun sendAdEvent(event: String, data: Map<String, Any>? = null) {
        val map = mutableMapOf<String, Any>("event" to event)
        if (data != null) map.putAll(data)
        eventSink?.success(map)
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
    val pubstarAdManagerWrapper = PubstarAdManagerWrapper.getInstance(mContext)

    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${Build.VERSION.RELEASE}")
        }
        "init" -> {
          pubstarAdManagerWrapper.init(
              onDone = {
                  result.success(true)
              },
              onError = { errorCode ->
                  result.error(errorCode.name, "init", null)
              }
          )
        }
        "loadAd" -> {
            val adId = call.argument<String>("adId")

            if (adId !is String) {
                result.error("loadAd", "Typeof adId is not a String", null)
                return
            }

            if (adId.trim().isEmpty()) {
                result.error("loadAd", "AdId is empty String", null)
                return
            }

            pubstarAdManagerWrapper.loadAd(
                adId,
                onLoaded = {
                    result.success(true)
                },
                onError = { errorCode ->
                    result.error(errorCode.name, "loadAd", null)
                }
            )
        }
        "showAd" -> {
            val adId = call.argument<String>("adId")

            if (adId !is String) {
                result.error("loadAd", "Typeof adId is not a String", null)
                return
            }

            if (adId.trim().isEmpty()) {
                result.error("loadAd", "AdId is empty String", null)
                return
            }

            pubstarAdManagerWrapper.showAd(
                adId,
                null,
                onAdHide = {
                    sendAdEvent("showAd_hide", mapOf("adId" to adId))
                },
                onAdShowed = {
                    sendAdEvent("showAd_showed", mapOf("adId" to adId))
                },
                onError = { errorCode ->
                    Log.e("PubstarIoPlugin", "showAd error onMethodCall: $errorCode")
                    sendAdEvent("showAd_error", mapOf("adId" to adId, "error" to errorCode.name))
                    result.error(errorCode.name, "showAd", null)
                }
            )
        }
        "showAdWithViewId" -> {
            val adId = call.argument<String>("adId")
            val viewId = call.argument<Int>("viewId")

            if (adId !is String) {
                result.error("loadAd", "Typeof adId is not a String", null)
                return
            }

            if (adId.trim().isEmpty()) {
                result.error("loadAd", "AdId is empty String", null)
                return
            }

            val adView = PubstarAdViewRegistry.views[viewId]

            if (adView == null) {
                Log.e("PubstarIoPlugin", "showAdWithViewId: AdView not found", null)
                result.error("NO_VIEW", "AdView not found", null)
                return
            }

            pubstarAdManagerWrapper.showAd(
                adId,
                adView,
                onAdHide = {
                    sendAdEvent("showAdWithViewId_hide", mapOf("adId" to adId))
                },
                onAdShowed = {
                    sendAdEvent("showAdWithViewId_showed", mapOf("adId" to adId))
                },
                onError = { errorCode ->
                    Log.e("PubstarIoPlugin", "showAdWithViewId error onMethodCall: $errorCode")
                    sendAdEvent("showAdWithViewId_error", mapOf("adId" to adId, "error" to errorCode.name))
                    result.error(errorCode.name, "showAd", null)
                }
            )
        }
        "loadAndShowAd" -> {
            val adId = call.argument<String>("adId")

            if (adId !is String) {
                result.error("loadAd", "Typeof adId is not a String", null)
                return
            }

            if (adId.trim().isEmpty()) {
                result.error("loadAd", "AdId is empty String", null)
                return
            }

            pubstarAdManagerWrapper.loadAndShowAd(
                adId,
                null,
                onAdLoaderError = { error ->
                    Log.e("PubstarIoPlugin", "onAdLoaderError error: $error")
                    sendAdEvent("loadAndShowAd_onAdLoaderError", mapOf("adId" to adId, "error" to error.name))
                    result.error(error.name, "onAdLoaderError", null)
                },
                onAdLoaded = {
                    sendAdEvent("loadAndShowAd_onAdLoaded", mapOf("adId" to adId))
                },
                onAdHide = {
                    sendAdEvent("loadAndShowAd_onAdHide", mapOf("adId" to adId))
                },
                onAdShowed = {
                    sendAdEvent("loadAndShowAd_onAdShowed", mapOf("adId" to adId))
                },
                onAdShowedError = { errorCode ->
                    Log.e("PubstarIoPlugin", "onAdShowedError error: $errorCode")
                    sendAdEvent("loadAndShowAd_onAdShowedError", mapOf("adId" to adId, "error" to errorCode.name))
                    result.error(errorCode.name, "showAd", null)
                }
            )
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
