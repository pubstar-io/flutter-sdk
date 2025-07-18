package com.tqc.pubstar_io

import io.flutter.plugin.common.EventChannel

class PubstarEventStreamHandler : EventChannel.StreamHandler {
    companion object {
        val shared = PubstarEventStreamHandler()
    }

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    private fun sendEvent(event: Any) {
        eventSink?.success(event)
    }

    fun sendAdEvent(event: PubstarAdEvent, adId: String, data: Map<String, Any?>? = null) {
        val eventData = mutableMapOf<String, Any?>(
            "event" to event.name,
            "adId" to adId
        )

        data?.forEach { (key, value) ->
            eventData[key] = value
        }

        sendEvent(eventData)
    }
}