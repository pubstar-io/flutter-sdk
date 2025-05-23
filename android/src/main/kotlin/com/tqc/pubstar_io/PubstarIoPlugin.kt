package com.tqc.pubstar_io

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
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

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pubstar_io")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val pubstarAdManagerWrapper = PubstarAdManagerWrapper.getInstance(mContext)

    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
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
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
