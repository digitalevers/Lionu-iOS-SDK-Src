//
//  CHConfigModel.m
//  HDPDeviceInfoSDK
//
//  Created by MacBook on 2021/2/27.
//

#import "ConfigModel.h"

@implementation ConfigModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _isMD5 = YES;   // 设置默认值为 YES
        _isAES = YES;   // 设置默认值为 YES
    }
    return self;
}

@end
