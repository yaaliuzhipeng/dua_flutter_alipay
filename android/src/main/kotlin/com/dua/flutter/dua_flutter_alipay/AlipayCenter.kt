package com.dua.flutter.fast_alipay

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.os.Message
import com.alipay.sdk.app.AuthTask
import com.alipay.sdk.app.EnvUtils
import com.alipay.sdk.app.PayTask

open class AlipayCenter private constructor() {
    companion object {
        const val TYPE_PAY = "pay"
        const val TYPE_AUTH = "auth"
        private var instance: AlipayCenter? = null
            get() {
                if (field == null) {
                    field = AlipayCenter()
                }
                return field
            }

        @Synchronized
        fun shared(): AlipayCenter {
            return instance!!
        }
    }


    fun setup() {
        //not required for android but ios
    }

    fun setEnv(sanbox: Boolean) {
        EnvUtils.setEnv(
            if (sanbox) EnvUtils.EnvEnum.SANDBOX else EnvUtils.EnvEnum.ONLINE
        )
    }

    fun pay(activity: Activity, order: String): Map<*, *> {
        val alipay = PayTask(activity)
        val result = alipay.payV2(order, false)
        return result
    }

    fun auth(activity: Activity, info: String): Map<*, *> {
        val alipay = AuthTask(activity)
        val result = alipay.authV2(info, true)
        return result
    }

    fun isInstalled(activity: Activity): List<Int> {
        val manager = activity.packageManager
        return if (manager == null) {
            listOf(0, 0)
        } else {
            val actionAlipayMainland = Intent(Intent.ACTION_VIEW)
            val actionAlipayHongkong = Intent(Intent.ACTION_VIEW)
            actionAlipayMainland.data = Uri.parse("alipays://")
            actionAlipayHongkong.data = Uri.parse("alipayhk://")
            listOf(
                if (manager.queryIntentActivities(actionAlipayMainland, PackageManager.GET_RESOLVED_FILTER).isNotEmpty()) 1 else 0,
                if (manager.queryIntentActivities(actionAlipayHongkong, PackageManager.GET_RESOLVED_FILTER).isNotEmpty()) 1 else 0,
            )
        }
    }

    fun version(activity: Activity): String {
        return PayTask(activity).version
    }

}
