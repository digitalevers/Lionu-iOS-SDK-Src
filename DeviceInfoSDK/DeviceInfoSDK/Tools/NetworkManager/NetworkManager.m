//
//  NetworkManager.m
//  LionuDeviceInfoSDK
//
//  Created by MacBook on 2021/2/27.
//

#import "NetworkManager.h"
#import "LionuDeviceInfoSDK.h"

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
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:totalParams options:NSJSONWritingPrettyPrinted error:nil];
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

@end
