//
//  SYBaseRequest.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/21.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYBaseRequest.h"
#import "SYNetworkUtil.h"
#import "SYNetworkConfig.h"
#import "SYNetworkManager.h"
#import "SYNetworkCacheManager.h"

@implementation SYBaseRequest

#pragma mark - Default Config

- (BOOL)enableCache {
    return NO;
}

- (BOOL)enableAccessory {
    return NO;
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodGET;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeHTTP;
}

- (NSString *)baseURL {
    return @"";
}

- (NSString *)requestPath {
    return @"";
}

- (id)requestParameters {
    return nil;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 20.0;
}

- (id)jsonObjectValidator {
    return nil;
}

- (NSDictionary<NSString *, NSString *> *)requestHeader {
    return nil;
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

#pragma mark - Public method

- (void)start {
    [self toggleAccessoriesStartCallBack];
    [[SYNetworkManager sharedInstance] addRequest:self];
}

- (void)stop {
    self.delegate = nil;
    [[SYNetworkManager sharedInstance] removeRequest:self];
    [self toggleAccessoriesStopCallBack];
}

- (void)startWithBlockSuccess:(SYRequestSuccessBlock)success
                      failure:(SYRequestFailureBlock)failure {
    self.successBlock = success;
    self.failureBlock = failure;
    [self start];
}

- (void)startWithBlockProgress:(SYRequestProgressBlock)progress
                       success:(SYRequestSuccessBlock)success
                       failure:(SYRequestFailureBlock)failure {
    self.progressBlock = progress;
    self.successBlock = success;
    self.failureBlock = failure;
    [self start];
}

- (void)clearCompletionBlock {
    self.progressBlock = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
}

#pragma mark - Property method

- (NSMutableArray<id<SYBaseRequestAccessory>> *)accessoryArray {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    return _accessoryArray;
}

- (NSString *)requestURLString {
    NSString *baseURL = nil;
    if (self.baseURL.length > 0) {
        baseURL = self.baseURL;
    } else {
        baseURL = [SYNetworkConfig sharedInstance].baseURL;
    }
    return [NSString stringWithFormat:@"%@%@", baseURL, self.requestPath];
}

- (NSInteger)responseStatusCode {
    return ((NSHTTPURLResponse *)self.sessionDataTask.response).statusCode;
}

- (NSDictionary *)responseHeader {
    return ((NSHTTPURLResponse *)self.sessionDataTask.response).allHeaderFields;
}

- (NSString *)responseString {
    return [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
}

- (id)responseJSONObject {
    NSError *error = nil;
    id responseJSONObject = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        SYNetworkLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        return responseJSONObject;
    }
}

- (NSData *)cacheData {
    NSString *cacheKey = [SYNetworkUtil cacheKeyWithRequest:self];
    return (NSData *)[[SYNetworkCacheManager sharedInstance] objectForKey:cacheKey];
}

- (id)cacheJSONObject {
    NSError *error = nil;
    NSString *cacheKey = [SYNetworkUtil cacheKeyWithRequest:self];
    NSData *cacheData = (NSData *)[[SYNetworkCacheManager sharedInstance] objectForKey:cacheKey];
    id cacheJSONObject = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        SYNetworkLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        return cacheJSONObject;
    }
}

@end

@implementation SYBaseRequest (RequestAccessory)

- (void)toggleAccessoriesStartCallBack {
    if (self.enableAccessory) {
        for (id<SYBaseRequestAccessory> accessory in self.accessoryArray) {
            if ([accessory respondsToSelector:@selector(requestStart:)]) {
                [accessory requestStart:self];
            }
        }
    }
}

- (void)toggleAccessoriesStopCallBack {
    if (self.enableAccessory) {
        for (id<SYBaseRequestAccessory> accessory in self.accessoryArray) {
            if ([accessory respondsToSelector:@selector(requestStop:)]) {
                [accessory requestStop:self];
            }
        }
    }
}

@end
