package com.dua.flutter.fast_alipay

import android.app.Activity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec

/** DuaFlutterAlipayPlugin */
class DuaFlutterAlipayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "dua_flutter_alipay",
            StandardMethodCodec.INSTANCE,
            flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue(),
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        var method = call.method
        var arguments = call.arguments
        when (method) {
            "setup" -> setup(arguments, result)
            "pay" -> pay(arguments, result)
            "auth" -> auth(arguments, result)
            "version" -> version(result)
            "isInstalled" -> isInstalled(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun throwInvalidArguments(result: Result) {
        result.error("-10086", "method arguments type error", null)
    }

    fun setup(arguments: Any, result: Result) {
        if (arguments is HashMap<*, *>) {
            AlipayCenter.shared().setup()
            AlipayCenter.shared().setEnv(arguments["env"] == "sandbox")
            result.success(true)
        } else {
            throwInvalidArguments(result)
        }
    }

    fun pay(arguments: Any, result: Result) {
        if (activity == null) return
        if (arguments is String) {
            val rs = AlipayCenter.shared().pay(activity!!, arguments as String)
            result.success(rs)
        } else {
            throwInvalidArguments(result)
        }
    }

    fun auth(arguments: Any, result: Result) {
        if (activity == null) return
        if (arguments is String) {
            val rs = AlipayCenter.shared().auth(activity!!, arguments)
            result.success(rs)
        } else {
            throwInvalidArguments(result)
        }
    }

    fun isInstalled(result: Result) {
        if (activity == null) return
        result.success(AlipayCenter.shared().isInstalled(activity!!))
    }

    fun version(result: Result) {
        if (activity == null) return
        result.success(AlipayCenter.shared().version(activity!!))
    }
}
