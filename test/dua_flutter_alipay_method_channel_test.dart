import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dua_flutter_alipay/dua_flutter_alipay_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDuaFlutterAlipay platform = MethodChannelDuaFlutterAlipay();
  const MethodChannel channel = MethodChannel('dua_flutter_alipay');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await platform.getPlatformVersion(), '42');
  // });
}
