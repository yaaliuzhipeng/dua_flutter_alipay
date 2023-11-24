//
//  DuaFlutterAlipayPlugin.m
//  dua_flutter_alipay
//
//  Created by _sseon on 2023/11/23.
//

#import "DuaFlutterAlipayPlugin.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation DuaFlutterAlipayPlugin {
    NSString* scheme;
    NSString* processing;
    FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"dua_flutter_alipay"
                                     binaryMessenger:[registrar messenger]];
    DuaFlutterAlipayPlugin* instance = [[DuaFlutterAlipayPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if(processing != nil) {
        processing = nil;
        if(flutterResult != nil){
            flutterResult(@{@"resultStatus": @"666",@"result": @"",@"memo": @""});
            flutterResult = nil;
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if([url.host isEqualToString:@"safepay"]){
        self->processing = nil;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAlipaySDKCallbackResult:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAlipaySDKCallbackResult:resultDic];
        }];
        return YES;
    }else{
        return NO;
    }
}

- (void) handleAlipaySDKCallbackResult: (NSDictionary *) dic
{
    if (flutterResult != nil) {
        processing = nil;
        flutterResult(dic);
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"setup" isEqualToString:call.method]) {
        [self setup:call.arguments result:result];
    } else if([@"version" isEqualToString:call.method]){
        [self version:result];
    } else if([@"isInstalled" isEqualToString:call.method]){
        [self isInstalled:result];
    } else if([@"pay" isEqualToString:call.method]){
        [self pay:call.arguments result:result];
    } else if([@"auth" isEqualToString:call.method]){
        [self auth:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) setup:(id _Nullable)arguments result:(FlutterResult) result
{
    NSString *urlScheme = [(NSDictionary *)arguments valueForKey:@"urlScheme"];
    scheme = urlScheme;
    result([NSNumber numberWithBool:YES]);
}

- (void) isInstalled:(FlutterResult) result
{
    NSURL *url1 = [NSURL URLWithString:@"alipays://"];
    NSURL *url2 = [NSURL URLWithString:@"alipay://"];
    NSURL *url3 = [NSURL URLWithString:@"alipayhk://"];
    NSNumber* mainland = @0;
    NSNumber* hongkong = @0;
    if([UIApplication.sharedApplication canOpenURL:url1] || [UIApplication.sharedApplication canOpenURL:url2]){
        mainland = @1;
    }
    if([UIApplication.sharedApplication canOpenURL:url3]){
        hongkong = @1;
    }
    result(@[mainland,hongkong]);
}

- (void) version:(FlutterResult) result
{
    result([[AlipaySDK defaultService] currentVersion]);
}

- (void) pay:(id _Nullable)arguments result:(FlutterResult) result
{
    processing = @"pay";
    flutterResult = result;
    [[AlipaySDK defaultService] payOrder:(NSString *) arguments fromScheme:scheme callback:^(NSDictionary *resultDic) {
        self->processing = nil;
        [self handleAlipaySDKCallbackResult:resultDic];
    }];
}

- (void) auth:(id _Nullable)arguments result:(FlutterResult) result
{
    processing = @"auth";
    flutterResult = result;
    [[AlipaySDK defaultService] auth_V2WithInfo:(NSString *)arguments fromScheme:scheme callback:^(NSDictionary *resultDic) {
        self->processing = nil;
        [self handleAlipaySDKCallbackResult:resultDic];
    }];
}
@end
