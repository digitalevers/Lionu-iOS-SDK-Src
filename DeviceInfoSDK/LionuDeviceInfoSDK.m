//
//  LionuDeviceInfoSDK.m
//  LionuDeviceInfoSDK
//
//  Created by MacBook on 2021/2/25.
//

#import "LionuDeviceInfoSDK.h"
#import "DeviceTool.h"
#import "NetworkManager.h"

#define LaunchAPI @"/receive/launch"
#define RegisterAPI @"/receive/reg"
#define PayAPI @"/receive/pay"

@implementation LionuDeviceInfoSDK

static LionuDeviceInfoSDK * _manager = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LionuDeviceInfoSDK alloc] init];
        _manager.configModel = [[ConfigModel alloc] init];
    });
    
    return _manager;
}

/**SDK初始化方法*/
-(void)initSDKWithHostUrl:(NSString *)hostUrl  APPID:(NSString *)appID{
    _manager.configModel.HostUrl = hostUrl;
    _manager.configModel.APPID = appID;
}

/**启动事件上报*/
-(void)startLaunchEvent{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [DeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    [[NetworkManager shareInstance] requestJsonPost:LaunchAPI params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (_manager.configModel.isLog) {
            NSLog(@"启动事件上报成功%@",responseObject);
        }

    } failBlock:^(NSError * _Nonnull error) {
        if (_manager.configModel.isLog) {
            NSLog(@"启动事件上报:%@",error);
        }

    }];
}

/**注册事件上报*/
-(void)startRegisterEvent{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [DeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    [[NetworkManager shareInstance] requestJsonPost:RegisterAPI params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (_manager.configModel.isLog) {
            NSLog(@"注册事件上报成功%@",responseObject);
        }

    } failBlock:^(NSError * _Nonnull error) {
        if (_manager.configModel.isLog) {
            NSLog(@"注册事件上报:%@",error);
        }
    }];
}

/**付费事件上报*/
-(void)startPayEventWithMoney:(NSString *)money{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * deviceDic = [DeviceTool getDeviceAllInfoDic];
    params[@"deviceInfo"] = deviceDic;
    params[@"amount"] = money;
    [[NetworkManager shareInstance] requestJsonPost:PayAPI params:params successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (_manager.configModel.isLog) {
            NSLog(@"付费事件上报成功%@",responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (_manager.configModel.isLog) {
            NSLog(@"付费事件上报:%@",error);
        }

    }];

}

@end
