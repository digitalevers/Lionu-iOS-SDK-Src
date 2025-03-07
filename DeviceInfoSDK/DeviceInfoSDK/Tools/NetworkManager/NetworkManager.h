//
//  NetworkManager.h
//  LionsuDeviceInfoSDK
//
//  Created by MacBook on 2021/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
+ (instancetype)shareInstance;

//请求URL
@property (nonatomic, copy) NSString *hostURL;
typedef void(^CHResponseSuccessBlock)(NSDictionary *responseObject);
typedef void(^CHResponseFailBlock)(NSError *error);

/**
 * @brief   GET请求方法
 * @author  yuancan
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
- (void)requestGET:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock;

/**
 * @brief   POST请求方法
 * @author  yuancan
 
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
- (void)requestPOST:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock;

/**
 * @brief   JSON格式网络接口请求方法
 * @author  yuancan
 *
 * @param relativePath 接口名称
 * @param params 请求参数
 * @param successBlock 请求成功回调
 * @param failBlock 请求失败回调
 */
- (void)requestJsonPost:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock;



@end

NS_ASSUME_NONNULL_END
