//
//  SYBatchRequest.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/24.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYBatchRequest.h"
#import "SYBatchRequestManager.h"
#import "SYBaseRequest.h"
#import "SYNetworkUtil.h"

@interface SYBatchRequest () <SYBaseRequestDelegate>

@property (nonatomic, strong) NSArray *requestArray;
@property (nonatomic, assign) NSInteger finishedRequestCount;

@end

@implementation SYBatchRequest

#pragma mark - LifeCycle

- (instancetype)initWithRequestArray:(NSArray<SYBaseRequest *> *)requestArray enableAccessory:(BOOL)enableAccessory {
    self = [super init];
    if (self) {
        _requestArray = requestArray.copy;
        _enableAccessory = enableAccessory;
        _finishedRequestCount = 0;
    }
    return self;
}

- (void)dealloc {
    [self clearBatchRequest];
}

#pragma mark - SYBaseRequest Delegate

- (void)requestSuccess:(SYBaseRequest *)request {
    self.finishedRequestCount++;
    if (self.finishedRequestCount == self.requestArray.count) {
        if ([self.delegate respondsToSelector:@selector(batchRequestSuccess:)]) {
            [self.delegate batchRequestSuccess:self];
        }
        if (self.successCompletionBlock) {
            self.successCompletionBlock(self);
        }
        [self batchRequestDidStop];
    }
}

- (void)requestFailure:(SYBaseRequest *)request error:(NSError *)error {
    for (SYBaseRequest *reqeust in self.requestArray) {
        [reqeust stop];
    }
    if ([self.delegate respondsToSelector:@selector(batchRequestFailure:)]) {
        [self.delegate batchRequestFailure:self];
    }
    if (self.failureCompletionBlock) {
        self.failureCompletionBlock(self);
    }
    [self batchRequestDidStop];
}

#pragma mark - Public method

- (void)start {
    if (self.finishedRequestCount > 0) {
        SYNetworkLog(@"Error! BatchRequest has already started.");
        return;
    }
    [self toggleAccessoriesStartCallBack];
    [[SYBatchRequestManager sharedInstance] addBatchRequest:self];
    for (SYBaseRequest *request in self.requestArray) {
        request.delegate = self;
        [request start];
    }
}

- (void)stop {
    [self clearBatchRequest];
    [self toggleAccessoriesStopCallBack];
    [[SYBatchRequestManager sharedInstance] removeBatchRequest:self];
}

- (void)startWithBlockSuccess:(void (^)(SYBatchRequest *))success failure:(void (^)(SYBatchRequest *))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - Property method

- (NSMutableArray<id<SYBaseRequestAccessory>> *)accessoryArray {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    return _accessoryArray;
}

#pragma mark - Private method

- (void)batchRequestDidStop {
    [self clearCompletionBlock];
    [self toggleAccessoriesStopCallBack];
    self.finishedRequestCount = 0;
    self.requestArray = nil;
    [[SYBatchRequestManager sharedInstance] removeBatchRequest:self];
}

- (void)clearBatchRequest {
    self.delegate = nil;
    for (SYBaseRequest *request in self.requestArray) {
        [request stop];
    }
    [self clearCompletionBlock];
}

@end

@implementation SYBatchRequest (RequestAccessory)

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
