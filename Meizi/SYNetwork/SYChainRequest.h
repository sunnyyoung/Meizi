//
//  SYChainRequest.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/31.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYBaseRequest;
@class SYChainRequest;
@protocol SYBaseRequestAccessory;

@protocol SYChainRequestDelegate <NSObject>

- (void)chainRequestSuccess:(SYChainRequest *)chainRequest;
- (void)chainRequest:(SYChainRequest *)chainRequest failure:(SYBaseRequest *)request;

@end

typedef void (^SYChainRequestCallback)(SYChainRequest *chainRequest, __kindof SYBaseRequest *request);

@interface SYChainRequest : NSObject

@property (nonatomic, weak) id <SYChainRequestDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray *requestArray;
@property (nonatomic, assign, readonly) BOOL enableAccessory;
@property (nonatomic, strong) NSMutableArray<id<SYBaseRequestAccessory>> *accessoryArray;

- (instancetype)initWithEnableAccessory:(BOOL)enableAccessory;

- (void)addRequest:(SYBaseRequest *)request callback:(SYChainRequestCallback)callback;
- (void)start;
- (void)stop;

@end

@interface SYChainRequest (RequestAccessory)

- (void)toggleAccessoriesStartCallBack;
- (void)toggleAccessoriesStopCallBack;

@end
