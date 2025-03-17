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
@property (nonatomic,assign) BOOL isMD5;//默认进行md5
@property (nonatomic,assign) BOOL isAES;//默认进行aes加密

@end

NS_ASSUME_NONNULL_END
