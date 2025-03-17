//
//  LionuDeviceInfoSDK.h
//  LionuDeviceInfoSDK
//
//  Created by MacBook on 2021/2/25.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

@interface LionuDeviceInfoSDK : NSObject
@property (nonatomic,strong) ConfigModel *configModel;



+(instancetype)shareInstance;
/**SDK初始化方法*/
-(void)initSDKWithHostUrl:(NSString *)hostUrl  APPID:(NSString *)appID;
/**启动事件上报*/
-(void)startLaunchEvent;
/**注册事件上报*/
-(void)startRegisterEvent;
/**付费事件上报*/
-(void)startPayEventWithMoney:(NSString *)money;
@end
