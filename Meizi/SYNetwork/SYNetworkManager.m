//
//  SYNetworkManager.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/21.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYNetworkManager.h"
#import "SYNetworkUtil.h"
#import "SYNetworkConfig.h"
#import "SYNetworkCacheManager.h"
#import "SYBaseRequest.h"

@interface SYNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *requestIdentifierDictionary;

@end

@implementation SYNetworkManager

#pragma mark - Life Cycle

+ (SYNetworkManager *)sharedInstance {
    static SYNetworkManager *instance;
    static dispatch_once_t SYNetworkManagerToken;
    dispatch_once(&SYNetworkManagerToken, ^{
        instance = [[SYNetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self manager];
        [self requestIdentifierDictionary];
    }
    return self;
}

#pragma mark - Public method

- (void)addRequest:(SYBaseRequest *)request {
    NSString *url = request.requestURLString;
    SYRequestMethod method = request.requestMethod;
    id parameters = request.requestParameters;
    //Request Serializer
    switch (request.requestSerializerType) {
        case SYRequestSerializerTypeHTTP: {
            self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        case SYRequestSerializerTypeJSON: {
            self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        default: {
            SYNetworkLog(@"Error, unsupport method type");
            break;
        }
    }
    self.manager.requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    //HTTPHeaderFields
    NSDictionary *requestHeaderFieldDictionary = request.requestHeader;
    if (requestHeaderFieldDictionary) {
        for (NSString *key in requestHeaderFieldDictionary.allKeys) {
            NSString *value = requestHeaderFieldDictionary[key];
            [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    switch (method) {
        case SYRequestMethodGET: {
            request.sessionDataTask = [self.manager GET:url
                                             parameters:parameters
                                               progress:^(NSProgress * _Nonnull downloadProgress) {
                                                   [self handleRequest:request progress:downloadProgress];
                                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [self handleRequestFailureWithSessionDatatask:task error:error];
                                               }];
            break;
        }
        case SYRequestMethodPOST: {
            if (request.constructingBodyBlock) {
                request.sessionDataTask = [self.manager POST:url
                                                  parameters:parameters
                                   constructingBodyWithBlock:request.constructingBodyBlock
                                                    progress:^(NSProgress * _Nonnull uploadProgress) {
                                                        [self handleRequest:request progress:uploadProgress];
                                                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                        [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                        [self handleRequestFailureWithSessionDatatask:task error:error];
                                                    }];
            } else {
                request.sessionDataTask = [self.manager POST:url
                                                  parameters:parameters
                                                    progress:^(NSProgress * _Nonnull downloadProgress) {
                                                        [self handleRequest:request progress:downloadProgress];
                                                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                        [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                        [self handleRequestFailureWithSessionDatatask:task error:error];
                                                    }];
            }
            break;
        }
        case SYRequestMethodHEAD: {
            request.sessionDataTask = [self.manager HEAD:url
                                              parameters:parameters
                                                 success:^(NSURLSessionDataTask * _Nonnull task) {
                                                     [self handleRequestSuccessWithSessionDataTask:task responseObject:nil];
                                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                     [self handleRequestFailureWithSessionDatatask:task error:error];
                                                 }];
            break;
        }
        case SYRequestMethodPUT: {
            request.sessionDataTask = [self.manager PUT:url
                                             parameters:parameters
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    [self handleRequestFailureWithSessionDatatask:task error:error];
                                                }];
            break;
        }
        case SYRequestMethodDELETE: {
            request.sessionDataTask = [self.manager DELETE:url
                                                parameters:parameters
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                       [self handleRequestFailureWithSessionDatatask:task error:error];
                                                   }];
            break;
        }
        case SYRequestMethodPATCH: {
            request.sessionDataTask = [self.manager PATCH:url
                                               parameters:parameters
                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                      [self handleRequestFailureWithSessionDatatask:task error:error];
                                                  }];
            break;
        }
        default: {
            SYNetworkLog(@"Error, unsupport method type");
            break;
        }
    }
    [self addRequestIdentifierWithRequest:request];
}

- (void)removeRequest:(SYBaseRequest *)request {
    [request.sessionDataTask cancel];
    [self removeRequestIdentifierWithRequest:request];
}

- (void)removeAllRequest {
    NSDictionary *requestIdentifierDictionary = self.requestIdentifierDictionary.copy;
    for (NSString *key in requestIdentifierDictionary.allValues) {
        SYBaseRequest *request = self.requestIdentifierDictionary[key];
        [request.sessionDataTask cancel];
        [self.requestIdentifierDictionary removeObjectForKey:key];
    }
}

#pragma mark - Private method

- (BOOL)isValidResultWithRequest:(SYBaseRequest *)request {
    BOOL result = YES;
    if (request.jsonObjectValidator != nil) {
        result = [SYNetworkUtil isValidateJSONObject:request.responseJSONObject
                             withJSONObjectValidator:request.jsonObjectValidator];
    }
    return result;
}

- (void)handleRequest:(SYBaseRequest *)request progress:(NSProgress *)progress {
    if ([request.delegate respondsToSelector:@selector(requestProgress:)]) {
        [request.delegate requestProgress:progress];
    }
    if (request.progressBlock) {
        request.progressBlock(progress);
    }
}

- (void)handleRequestSuccessWithSessionDataTask:(NSURLSessionDataTask *)sessionDataTask responseObject:(id)responseObject {
    NSString *key = @(sessionDataTask.taskIdentifier).stringValue;
    SYBaseRequest *request = self.requestIdentifierDictionary[key];
    request.responseData = responseObject;
    if (request) {
        if ([self isValidResultWithRequest:request]) {
            if (request.enableCache) {
                NSString *cacheKey = [SYNetworkUtil cacheKeyWithRequest:request];
                [[SYNetworkCacheManager sharedInstance] setObject:request.responseData forKey:cacheKey];
            }
            if ([request.delegate respondsToSelector:@selector(requestSuccess:)]) {
                [request.delegate requestSuccess:request];
            }
            if (request.successBlock) {
                request.successBlock(request);
            }
            [request toggleAccessoriesStopCallBack];
        } else {
            SYNetworkLog(@"Request %@ failed, status code = %@", NSStringFromClass([request class]), @(request.responseStatusCode));
            if ([request.delegate respondsToSelector:@selector(requestFailure:error:)]) {
                [request.delegate requestFailure:request error:nil];
            }
            if (request.failureBlock) {
                request.failureBlock(request, nil);
            }
            [request toggleAccessoriesStopCallBack];
        }
    }
    [request clearCompletionBlock];
    [self removeRequestIdentifierWithRequest:request];
}

- (void)handleRequestFailureWithSessionDatatask:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error {
    NSString *key = @(sessionDataTask.taskIdentifier).stringValue;
    SYBaseRequest *request = self.requestIdentifierDictionary[key];
    request.responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (request) {
        if ([request.delegate respondsToSelector:@selector(requestFailure:error:)]) {
            [request.delegate requestFailure:request error:error];
        }
        if (request.failureBlock) {
            request.failureBlock(request, error);
        }
        [request toggleAccessoriesStopCallBack];
    }
    [request clearCompletionBlock];
    [self removeRequestIdentifierWithRequest:request];
}

- (void)addRequestIdentifierWithRequest:(SYBaseRequest *)request {
    if (request.sessionDataTask != nil) {
        NSString *key = @(request.sessionDataTask.taskIdentifier).stringValue;
        @synchronized (self) {
            [self.requestIdentifierDictionary setObject:request forKey:key];
        }
    }
    SYNetworkLog(@"Add request: %@", NSStringFromClass([request class]));
}

- (void)removeRequestIdentifierWithRequest:(SYBaseRequest *)request {
    NSString *key = @(request.sessionDataTask.taskIdentifier).stringValue;
    @synchronized (self) {
        [self.requestIdentifierDictionary removeObjectForKey:key];
    }
    SYNetworkLog(@"Request queue size = %@", @(self.requestIdentifierDictionary.count));
}

#pragma mark - Property method

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        SYNetworkConfig *config = [SYNetworkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy = config.securityPolicy;
        _manager.operationQueue.maxConcurrentOperationCount = config.maxConcurrentOperationCount;
    }
    return _manager;
}

- (NSMutableDictionary *)requestIdentifierDictionary {
    if (_requestIdentifierDictionary == nil) {
        _requestIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return _requestIdentifierDictionary;
}

@end
