import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dua_flutter_alipay/dua_alipay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    await DuaAlipay.setup(urlScheme: "runner");
    var version = await DuaAlipay.version;
    debugPrint("支付宝version: $version");
    var installed = await DuaAlipay.installed;
    debugPrint("支付宝installed: ${installed.mainland}    hongkong: ${installed.hongkong}");
    var payResult = await DuaAlipay.pay("order str info");
    // payResult.success ? debugPrint("支付成功") : debugPrint("支付失败");
    debugPrint("支付宝支付结果描述: ${payResult.description}");
    debugPrint("支付宝支付SDK结果memo: ${payResult.memo}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
