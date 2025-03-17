//
//  NetworkManager.m
//  LionuDeviceInfoSDK
//
//  Created by MacBook on 2021/2/27.
//

#import "NetworkManager.h"
#import "LionuDeviceInfoSDK.h"
//aes加密算法相关
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation NetworkManager

+ (instancetype)shareInstance{
    static NetworkManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetworkManager alloc] init];
        [_manager configure];
    });
    return _manager;
}

/**基础配置*/
- (void)configure{
    self.hostURL = [LionuDeviceInfoSDK shareInstance].configModel.HostUrl;
}

/**设置公用参数*/
- (NSDictionary *)getCommonParams{
    //公用参数
    NSMutableDictionary * commonParams = [NSMutableDictionary dictionary];
    NSString * appID = [LionuDeviceInfoSDK shareInstance].configModel.APPID;
    if (appID.length > 0) {
        commonParams[@"appid"] = appID;
    }else{
        NSLog(@"请传入APPID");
    }
    commonParams[@"os"] = @"2";//1 Android 2 IOS
    return commonParams.copy;
}

/**请求封装*/
- (void)requestHTTPMethod:(NSString *)httpMenthod relativePath:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock{
        
    NSInteger keysCount = [params allKeys].count;
    NSMutableString *paramsString = [[NSMutableString alloc] initWithCapacity:0];
    for (int i=0;i< keysCount;i++) {
        NSString *key = [[params allKeys] objectAtIndex:i];
        [paramsString appendString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
        if (i < keysCount-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.hostURL, relativePath];
    if ([LionuDeviceInfoSDK shareInstance].configModel.isLog) {
        NSLog(@"urlString:%@ params:%@",urlString,params);
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = httpMenthod;
    request.HTTPBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           if (!error) {
                if (successBlock) {
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    successBlock(responseObject);
                }
            } else {
                if (failBlock) {
                    failBlock(error);
                }
            }
        });
    }];
    [dataTask resume];
}

/**GET请求*/
- (void)requestGET:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock{
    
    //传入参数 公用参数 拼装
    NSMutableDictionary * totalParams = [NSMutableDictionary dictionary];
    NSDictionary * commonParams = [self getCommonParams];
    [totalParams addEntriesFromDictionary:commonParams];
    [totalParams addEntriesFromDictionary:params];
  
    [self requestHTTPMethod:@"GET" relativePath:relativePath params:totalParams successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

/**POST请求*/
- (void)requestPOST:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock{
    
    //传入参数 公用参数 拼装
    NSMutableDictionary * totalParams = [NSMutableDictionary dictionary];
    NSDictionary * commonParams = [self getCommonParams];
    [totalParams addEntriesFromDictionary:commonParams];
    [totalParams addEntriesFromDictionary:params];

    [self requestHTTPMethod:@"POST" relativePath:relativePath params:totalParams successBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            return successBlock(responseObject);
        }
    } failBlock:^(NSError * _Nonnull error) {
        if (failBlock) {
            return failBlock(error);
        }
    }];
}

/**JSON POST请求*/
- (void)requestJsonPost:(NSString *)relativePath params:(NSDictionary *)params successBlock:(CHResponseSuccessBlock)successBlock failBlock:(CHResponseFailBlock)failBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.hostURL, relativePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    //传入参数 公用参数 拼装
    NSMutableDictionary * totalParams = [NSMutableDictionary dictionary];
    NSDictionary * commonParams = [self getCommonParams];
    [totalParams addEntriesFromDictionary:commonParams];
    [totalParams addEntriesFromDictionary:params];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:totalParams options:NSJSONWritingPrettyPrinted error:nil];
    if ([LionuDeviceInfoSDK shareInstance].configModel.isAES) {
        // AES 加密密钥在SDK外部设置
        NSString *base64key = [LionuDeviceInfoSDK shareInstance].configModel.base64AesKey;
        // 对 JSON 数据进行 AES 加密
        NSData *encryptedData = [self aesEncryptData:jsonData key:base64key mode:kCCOptionECBMode iv:nil];
        NSString *encryptedBase64 = [encryptedData base64EncodedStringWithOptions:0];
        NSData *httpbody = [encryptedBase64 dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = httpbody;
    } else {
        request.HTTPBody = jsonData;
    }
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (successBlock) {
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    successBlock(responseObject);
                }
            } else {
                if (failBlock) {
                    failBlock(error);
                }
            }
        });
    }];
    [dataTask resume];
}

// AES 加密方法
- (NSData *)aesEncryptData:(NSData *)data key:(NSString *)base64key mode:(CCMode)mode iv:(NSData *)iv {
    //NSData *keyData = [NSData dataFromBase64String:base64Key];
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:base64key options:0];
    if (!keyData) {
        NSLog(@"Invalid Base64 Key");
        return nil;
    }
    
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, // 加密操作
                                          kCCAlgorithmAES128, // 使用 AES-128 算法
                                          mode | kCCOptionPKCS7Padding, // 加密模式和填充模式
                                          keyData.bytes, // 密钥
                                          keyData.length, // 密钥长度
                                          iv ? iv.bytes : NULL, // 初始化向量（IV）
                                          [data bytes], // 输入数据
                                          data.length, // 输入数据长度
                                          buffer, // 输出缓冲区
                                          bufferSize, // 输出缓冲区大小
                                          &numBytesEncrypted); // 实际加密的字节数

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted]; // 返回加密后的数据
    }

    free(buffer); // 释放缓冲区
    return nil; // 加密失败
}

@end
