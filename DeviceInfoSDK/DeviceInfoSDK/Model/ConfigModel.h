//
//  CHConfigModel.h
//  HDPDeviceInfoSDK
//
//  Created by MacBook on 2021/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject
@property (nonatomic,copy) NSString * HostUrl;
@property (nonatomic,copy) NSString *APPID;
@property (nonatomic,assign) BOOL isLog;//默认不打印

@end

NS_ASSUME_NONNULL_END
