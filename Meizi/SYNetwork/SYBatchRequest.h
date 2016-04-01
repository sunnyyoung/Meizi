//
//  SYBatchRequest.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/24.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYBaseRequest;
@class SYBatchRequest;
@protocol SYBaseRequestAccessory;

@protocol SYBatchRequestDelegate <NSObject>

- (void)batchRequestSuccess:(SYBatchRequest *)batchRequest;
- (void)batchRequestFailure:(SYBatchRequest *)batchRequest;

@end

@interface SYBatchRequest : NSObject

@property (nonatomic, weak) id <SYBatchRequestDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *requestArray;
@property (nonatomic, assign, readonly) BOOL enableAccessory;
@property (nonatomic, strong) NSMutableArray<id<SYBaseRequestAccessory>> *accessoryArray;
@property (nonatomic, copy) void (^successCompletionBlock)(SYBatchRequest *request);
@property (nonatomic, copy) void (^failureCompletionBlock)(SYBatchRequest *request);

- (instancetype)initWithRequestArray:(NSArray<SYBaseRequest *> *)requestArray enableAccessory:(BOOL)enableAccessory;

- (void)start;
- (void)stop;
- (void)startWithBlockSuccess:(void (^)(SYBatchRequest *request))success
                      failure:(void (^)(SYBatchRequest *request))failure;

- (void)clearCompletionBlock;

@end

@interface SYBatchRequest (RequestAccessory)

- (void)toggleAccessoriesStartCallBack;
- (void)toggleAccessoriesStopCallBack;

@end
