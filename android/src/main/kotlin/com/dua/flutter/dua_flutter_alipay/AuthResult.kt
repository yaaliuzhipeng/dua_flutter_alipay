package com.dua.flutter.fast_alipay

import android.text.TextUtils

class AuthResult(rawResult: Map<String?, String?>?, removeBrackets: Boolean) {
    /**
     * @return the resultStatus
     */
    var resultStatus: String? = null

    /**
     * @return the result
     */
    var result: String? = null

    /**
     * @return the memo
     */
    var memo: String? = null

    /**
     * @return the resultCode
     */
    var resultCode: String? = null

    /**
     * @return the authCode
     */
    var authCode: String? = null

    /**
     * @return the alipayOpenId
     */
    var alipayOpenId: String? = null

    init {
        if (rawResult != null) {
            for (key in rawResult!!.keys) {
                if (TextUtils.equals(key, "resultStatus")) {
                    resultStatus = rawResult[key]
                } else if (TextUtils.equals(key, "result")) {
                    result = rawResult[key]
                } else if (TextUtils.equals(key, "memo")) {
                    memo = rawResult[key]
                }
            }
            val resultValue = result!!.split("&".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            for (value in resultValue) {
                if (value.startsWith("alipay_open_id")) {
                    alipayOpenId = removeBrackets(getValue("alipay_open_id=", value), removeBrackets)
                    continue
                }
                if (value.startsWith("auth_code")) {
                    authCode = removeBrackets(getValue("auth_code=", value), removeBrackets)
                    continue
                }
                if (value.startsWith("result_code")) {
                    resultCode = removeBrackets(getValue("result_code=", value), removeBrackets)
                    continue
                }
            }
        }
    }

    private fun removeBrackets(str: String, remove: Boolean): String {
        var str = str
        if (remove) {
            if (!TextUtils.isEmpty(str)) {
                if (str.startsWith("\"")) {
                    str = str.replaceFirst("\"".toRegex(), "")
                }
                if (str.endsWith("\"")) {
                    str = str.substring(0, str.length - 1)
                }
            }
        }
        return str
    }

    override fun toString(): String {
        return "authCode={$authCode}; resultStatus={$resultStatus}; memo={$memo}; result={$result}"
    }

    private fun getValue(header: String, data: String): String {
        return data.substring(header.length, data.length)
    }
}