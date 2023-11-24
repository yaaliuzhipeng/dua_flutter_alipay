import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dua_flutter_alipay_method_channel.dart';

abstract class DuaFlutterAlipayPlatform extends PlatformInterface {
  /// Constructs a DuaFlutterAlipayPlatform.
  DuaFlutterAlipayPlatform() : super(token: _token);

  static final Object _token = Object();

  static DuaFlutterAlipayPlatform _instance = MethodChannelDuaFlutterAlipay();

  /// The default instance of [DuaFlutterAlipayPlatform] to use.
  ///
  /// Defaults to [MethodChannelDuaFlutterAlipay].
  static DuaFlutterAlipayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DuaFlutterAlipayPlatform] when
  /// they register themselves.
  static set instance(DuaFlutterAlipayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> setup(Map options) {
    throw UnimplementedError('setup() has not been implemented.');
  }

  Future<String?> version() {
    throw UnimplementedError('version() has not been implemented.');
  }

  Future<List<int>?> isInstalled() {
    throw UnimplementedError('isInstalled() has not been implemented.');
  }

  Future<Map?> pay(String order) {
    throw UnimplementedError('pay(String order) has not been implemented.');
  }

  Future<Map?> auth(String info) {
    throw UnimplementedError('auth(String order) has not been implemented.');
  }
}
