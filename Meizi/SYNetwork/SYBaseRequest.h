//
//  SYBaseRequest.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/21.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import <YYCache/YYCache.h>

@class SYBaseRequest;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^SYRequestSuccessBlock)(__kindof SYBaseRequest *request);
typedef void (^SYRequestFailureBlock)(__kindof SYBaseRequest *request, NSError *error);
typedef void (^SYRequestProgressBlock)(NSProgress *progress);

typedef NS_ENUM(NSInteger , SYRequestMethod) {
    SYRequestMethodGET = 0,
    SYRequestMethodPOST,
    SYRequestMethodHEAD,
    SYRequestMethodPUT,
    SYRequestMethodDELETE,
    SYRequestMethodPATCH
};

typedef NS_ENUM(NSUInteger, SYRequestSerializerType) {
    SYRequestSerializerTypeHTTP = 0,
    SYRequestSerializerTypeJSON
};

@protocol SYBaseRequestDelegate <NSObject>

@optional
- (void)requestSuccess:(SYBaseRequest *)request;
- (void)requestFailure:(SYBaseRequest *)request error:(NSError *)error;
- (void)requestProgress:(NSProgress *)progress;

@end

@protocol SYBaseRequestAccessory <NSObject>

@optional
- (void)requestStart:(id)request;
- (void)requestStop:(id)request;

@end

@interface SYBaseRequest : NSObject

@property (nonatomic, weak) id <SYBaseRequestDelegate> delegate;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, strong) NSMutableArray<id<SYBaseRequestAccessory>> *accessoryArray;
@property (nonatomic, copy) SYRequestSuccessBlock successBlock;
@property (nonatomic, copy) SYRequestFailureBlock failureBlock;
@property (nonatomic, copy) SYRequestProgressBlock progressBlock;

//Response
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong, readonly) NSString *requestURLString;
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;
@property (nonatomic, strong, readonly) NSDictionary *responseHeader;
@property (nonatomic, strong, readonly) NSString *responseString;
@property (nonatomic, strong, readonly) id responseJSONObject;

//Cache
@property (nonatomic, strong, readonly) NSData *cacheData;
@property (nonatomic, strong, readonly) id cacheJSONObject;

- (BOOL)enableCache;
- (BOOL)enableAccessory;
- (SYRequestMethod)requestMethod;
- (SYRequestSerializerType)requestSerializerType;
- (NSString *)baseURL;
- (NSString *)requestPath;
- (id)requestParameters;
- (NSTimeInterval)requestTimeoutInterval;
- (id)jsonObjectValidator;
- (NSDictionary<NSString *, NSString *> *)requestHeader;
- (AFConstructingBlock)constructingBodyBlock;

- (void)start;
- (void)stop;
- (void)startWithBlockSuccess:(SYRequestSuccessBlock)success
                      failure:(SYRequestFailureBlock)failure;
- (void)startWithBlockProgress:(SYRequestProgressBlock)progress
                       success:(SYRequestSuccessBlock)success
                       failure:(SYRequestFailureBlock)failure;

- (void)clearCompletionBlock;

@end

@interface SYBaseRequest (RequestAccessory)

- (void)toggleAccessoriesStartCallBack;
- (void)toggleAccessoriesStopCallBack;

@end
