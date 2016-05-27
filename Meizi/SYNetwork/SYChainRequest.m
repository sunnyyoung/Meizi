//
//  SYChainRequest.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/31.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYChainRequest.h"
#import "SYChainRequestManager.h"
#import "SYBaseRequest.h"
#import "SYNetworkUtil.h"

@interface SYChainRequest () <SYBaseRequestDelegate>

@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, strong) NSMutableArray *requestCallbackArray;
@property (nonatomic, assign) NSUInteger nextRequestIndex;

@end

@implementation SYChainRequest

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _nextRequestIndex = 0;
    }
    return self;
}

- (instancetype)initWithEnableAccessory:(BOOL)enableAccessory {
    self = [self init];
    if (self) {
        _enableAccessory = enableAccessory;
    }
    return self;
}

- (void)dealloc {
    [self clearChainRequest];
}

#pragma mark - SYBaseRequest Delegate

- (void)requestSuccess:(SYBaseRequest *)request {
    NSUInteger currentRequestIndex = self.nextRequestIndex - 1;
    SYChainRequestCallback callback = self.requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if ([self startNextRequest] == NO) {
        [self toggleAccessoriesStopCallBack];
        if ([self.delegate respondsToSelector:@selector(chainRequestSuccess:)]) {
            [self.delegate chainRequestSuccess:self];
        }
        [self chainRequestDidStop];
    }
}

- (void)requestFailure:(SYBaseRequest *)request error:(NSError *)error {
    [self toggleAccessoriesStopCallBack];
    if ([self.delegate respondsToSelector:@selector(chainRequest:failure:)]) {
        [self.delegate chainRequest:self failure:request];
    }
    [self chainRequestDidStop];
}

#pragma mark - Public method

- (void)addRequest:(SYBaseRequest *)request callback:(SYChainRequestCallback)callback {
    [self.requestArray addObject:request];
    if (callback) {
        [self.requestCallbackArray addObject:callback];
    } else {
        [self.requestCallbackArray addObject:^(SYChainRequest *chainRequest, SYBaseRequest *request) {}];
    }
}

- (void)start {
    if (self.nextRequestIndex > 0) {
        SYNetworkLog(@"Error! BatchRequest has already started.");
        return;
    }
    if (self.requestArray.count > 0) {
        [self toggleAccessoriesStartCallBack];
        [self startNextRequest];
        [[SYChainRequestManager sharedInstance] addChainRequest:self];
    } else {
        SYNetworkLog(@"Error! Chain request array is empty.");
    }
}

- (void)stop {
    [self clearChainRequest];
    [self toggleAccessoriesStopCallBack];
    [[SYChainRequestManager sharedInstance] removeChainRequest:self];
}

#pragma mark - Private method

- (BOOL)startNextRequest {
    if (self.nextRequestIndex < self.requestArray.count) {
        SYBaseRequest *request = self.requestArray[self.nextRequestIndex];
        self.nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
    } else {
        return NO;
    }
}

- (void)chainRequestDidStop {
    [self toggleAccessoriesStopCallBack];
    self.nextRequestIndex = 0;
    [self.requestArray removeAllObjects];
    [self.requestCallbackArray removeAllObjects];
    [[SYChainRequestManager sharedInstance] removeChainRequest:self];
}

- (void)clearChainRequest {
    NSUInteger currentRequestIndex = self.nextRequestIndex - 1;
    if (currentRequestIndex < self.requestArray.count) {
        SYBaseRequest *request = self.requestArray[currentRequestIndex];
        [request stop];
    }
    [self.requestArray removeAllObjects];
    [self.requestCallbackArray removeAllObjects];
}

#pragma mark - Property method

- (NSMutableArray<id<SYBaseRequestAccessory>> *)accessoryArray {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    return _accessoryArray;
}

@end

@implementation SYChainRequest (RequestAccessory)

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
