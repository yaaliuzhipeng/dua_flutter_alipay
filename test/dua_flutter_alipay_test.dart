import 'package:flutter_test/flutter_test.dart';
import 'package:dua_flutter_alipay/dua_alipay.dart';
import 'package:dua_flutter_alipay/dua_flutter_alipay_platform_interface.dart';
import 'package:dua_flutter_alipay/dua_flutter_alipay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDuaFlutterAlipayPlatform with MockPlatformInterfaceMixin implements DuaFlutterAlipayPlatform {
  @override
  Future<Map?> pay(String order) => Future.value({'resultStatus': "9000"});

  @override
  Future<Map?> auth(String info) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>?> isInstalled() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setup(Map options) {
    throw UnimplementedError();
  }

  @override
  Future<String?> version() {
    throw UnimplementedError();
  }
}

void main() {
  final DuaFlutterAlipayPlatform initialPlatform = DuaFlutterAlipayPlatform.instance;

  test('$MethodChannelDuaFlutterAlipay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDuaFlutterAlipay>());
  });
}
