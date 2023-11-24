import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dua_flutter_alipay_platform_interface.dart';

/// An implementation of [DuaFlutterAlipayPlatform] that uses method channels.
class MethodChannelDuaFlutterAlipay extends DuaFlutterAlipayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dua_flutter_alipay');

  @override
  Future<bool?> setup(Map options) async {
    return await methodChannel.invokeMethod<bool>('setup', options);
  }

  @override
  Future<String?> version() async {
    return await methodChannel.invokeMethod<String>('version');
  }

  @override
  Future<List<int>?> isInstalled() async {
    var rs = await methodChannel.invokeMethod('isInstalled');
    return (rs[0] is int) ? [rs[0], rs[1]] : [0, 0];
  }

  @override
  Future<Map?> pay(String order) async {
    return await methodChannel.invokeMethod<Map>('pay', order);
  }

  @override
  Future<Map?> auth(String info) async {
    return await methodChannel.invokeMethod<Map>('auth', info);
  }
}
