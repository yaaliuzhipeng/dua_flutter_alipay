import 'dart:io';

import 'dua_flutter_alipay_platform_interface.dart';

class DuaAlipay {
  static bool _isIosSetupCalled = false;

  /// @param sandbox 是否是沙盒环境 [android]
  /// @param urlScheme iOS支付宝回调的urlScheme [iOS]
  static Future<void> setup({bool? sandbox, String? urlScheme}) async {
    await DuaFlutterAlipayPlatform.instance.setup({'env': sandbox == true ? 'sandbox' : 'normal', 'urlScheme': urlScheme ?? ''});
    _isIosSetupCalled = true;
  }

  /// 获取支付宝SDK版本号
  static Future<String> get version async {
    return await DuaFlutterAlipayPlatform.instance.version() ?? "unknown";
  }

  /// 获取支付宝是否安装
  static Future<DuaAlipayInstalled> get installed async {
    var isInstalled = await DuaFlutterAlipayPlatform.instance.isInstalled() ?? [0, 0];
    return DuaAlipayInstalled(isInstalled[0] == 1, isInstalled[1] == 1);
  }

  /// 支付宝支付
  static Future<DuaAlipayResult> pay(String order) async {
    if (!_isIosSetupCalled && Platform.isIOS) {
      throw Exception("请先调用setup方法");
    }
    var rs = await DuaFlutterAlipayPlatform.instance.pay(order);
    var resultStatus = rs!['resultStatus'];
    return DuaAlipayResult("pay", resultStatus: _handleStatus(resultStatus), result: rs['result'], memo: rs['memo']);
  }

  /// 支付宝授权
  static Future<DuaAlipayResult> auth(String info) async {
    if (!_isIosSetupCalled && Platform.isIOS) {
      throw Exception("请先调用setup方法");
    }
    var rs = await DuaFlutterAlipayPlatform.instance.auth(info);
    var resultStatus = rs!['resultStatus'];
    return DuaAlipayResult("auth", resultStatus: _handleStatus(resultStatus), result: rs['result'], memo: rs['memo']);
  }

  static int _handleStatus(dynamic resultStatus) {
    var status = -1;
    if (resultStatus != null && resultStatus is String) {
      status = int.parse(resultStatus);
    }
    return status;
  }
}

class DuaAlipayInstalled {
  final bool mainland;
  final bool hongkong;
  DuaAlipayInstalled(this.mainland, this.hongkong);
}

class DuaAlipayResult {
  DuaAlipayResult(this.type, {int? resultStatus, String? result, String? memo})
      : status = resultStatus ?? -1,
        result = result ?? '',
        memo = memo ?? '';
  final String type;
  final int status;
  final String result;
  final String memo;

  bool get success => status == 9000;

  /// [ios] 支付宝支付结果回调中断
  /// 通常为支付完成后、用户未直接从支付宝端返回。而是通过其他方式返回、比如回到主屏幕后
  /// 主动返回app、此时支付宝支付结果回调中断
  bool get payCallbackInterupted => status == 666;

  String get description {
    switch (status) {
      case 9000:
        return type == "pay" ? "支付成功" : "授权成功";
      case 9001:
        return "等待支付宝端完成认证";
      case 6001:
        return type == "pay" ? "用户已取消支付" : "用户已取消授权";
      case 6002:
        return "网络错误";
      case 5000:
        return "请勿短时间内重复请求";
      case 4000:
        return "系统繁忙，请稍后再试";
      case 4001:
        return "未安装支付宝客户端";
      case 666:
        return "等待支付结果确认";
    }
    return type == "pay" ? "支付失败" : "授权失败";
  }

  String get descriptionEn {
    switch (status) {
      case 9000:
        return type == "pay" ? "Payment successful" : "Authorization successful";
      case 9001:
        return "Waiting for Alipay to complete authentication";
      case 6001:
        return type == "pay" ? "User has cancelled payment" : "User has cancelled authorization";
      case 6002:
        return "Network error";
      case 5000:
        return "Please do not repeat the request in a short time";
      case 4000:
        return "System busy, please try again later";
      case 4001:
        return "Alipay client is not installed";
      case 666:
        return "Waiting for payment result confirmation";
    }
    return type == "pay" ? "Payment failed" : "Authorization failed";
  }

  DuaAlipayAuthResultDetail? get authResultDetail {
    if (type == "pay" || status != 9000) return null;
    var resultValue = result.split("&");
    var alipayOpenId = "";
    var authCode = "";
    var resultCode = "";
    for (var value in resultValue) {
      if (value.startsWith("alipay_open_id")) {
        alipayOpenId = _removeBrackets(value.substring("alipay_open_id=".length, value.length));
      }
      if (value.startsWith("auth_code")) {
        authCode = _removeBrackets(value.substring("auth_code=".length, value.length));
      }
      if (value.startsWith("result_code")) {
        resultCode = _removeBrackets(value.substring("result_code=".length, value.length));
      }
    }
    return DuaAlipayAuthResultDetail(authCode, alipayOpenId, resultCode);
  }

  String _removeBrackets(String str) {
    var out = str;
    if (str.isEmpty) return out;
    if (out.startsWith("\"")) {
      out = out.substring(1, out.length);
    }
    if (out.endsWith("\"")) {
      out = out.substring(0, out.length - 1);
    }
    return out;
  }
}

class DuaAlipayAuthResultDetail {
  DuaAlipayAuthResultDetail(this.authCode, this.alipayOpenId, this.resultCode);
  final String authCode;
  final String alipayOpenId;
  final String resultCode;
}
